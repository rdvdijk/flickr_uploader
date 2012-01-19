require 'progressbar'

module FlickrUploader
  class SetCreator
    include Configuration

    def initialize(set_name)
      @set_name = set_name
      initialize_uploader
    end

    # Loop over all JPG files and upload them to a set.
    def upload_files(file_paths)
      logger.info "Starting upload of #{file_paths.size} photos to photoset '#{@set_name}'."
      pbar = ProgressBar.new("Upload", file_paths.size)
      pbar.bar_mark = '='

      file_paths.each do |file_path|
        filename = File.basename(file_path)
        logger.debug "Uploading: #{filename} .. "

        unless photo_uploaded?(filename)
          upload_file(file_path)
        else
          logger.info "Skipping, already uploaded! #(photo_id = #{photos_by_name(filename).map(&:id).join(' ')})"
        end
        pbar.inc
      end

      pbar.finish
      logger.info "Done uploading #{file_paths.size} photos to photoset '#{@set_name}'."
    end

    private

    def upload_file(file_path)
      # upload photo
      log_speed(File.size(file_path)) do
        result = @uploader.upload(file_path)

        photo_id = result.photoid.to_s
        logger.debug "Success! (photo_id = #{photo_id}) .. "

        # add photo to set
        add_to_set(@set_name, photo_id)
      end
    end

    def log_speed(size)
      start = Time.now.to_f
      yield
      finish = Time.now.to_f
      logger.debug "Speed: #{((size / (finish - start)) / 1024.0).round(1)}KiB/s"
    end

    def initialize_uploader
      initialize_flickr
      @uploader = Flickr::Uploader.new(@flickr)

      # Find set, if it exists. This also triggers initial authentication.. (which is needed!)
      @set = find_set(@set_name)
    end

    def find_set(name)
      @photosets = Flickr::Photosets.new(@flickr)
      @photosets.get_list.find { |set| set.title == name }
    end

    def create_set(set_name, photo_id)
      logger.debug "Creating new set '#{set_name}'"
      @photosets.create(set_name, photo_id)
      find_set(set_name)
    end

    def add_to_set(set_name, photo_id)
      if !@set
        @set = create_set(set_name, photo_id)
      else
        logger.debug "Adding to existing set '#{set_name}'"
        @set.add_photo(photo_id)
      end
    end

    def photo_uploaded?(filename)
      return false unless @set
      photos_by_name(filename).any?
    end

    def photos_by_name(filename)
      return [] unless @set
      @photos ||= @set.get_photos
      base_filename = File.basename(filename, File.extname(filename))
      @photos.select { |photo| photo.title == base_filename }
    end

    def logger
      @logger ||= create_logger
    end

    def create_logger
      logger = Logger.new(STDOUT)
      logger.level = Logger::INFO
      logger.formatter = proc do |severity, datetime, progname, msg|
        "[#{severity}][#{datetime.strftime('%H:%M:%S')}] #{msg}\n"
      end
      logger
    end

  end
end
