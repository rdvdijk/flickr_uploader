module FlickrUploader
  class SetCreator
    include Configuration

    def initialize(set_name)
      @logger = Logger.new(STDOUT)
      @set_name = set_name
      initialize_uploader
    end

    def upload_files(file_paths)
      file_paths.each do |file_path|
        filename = File.basename(file_path)
        logger.info "Uploading: #{filename} .. "

        unless photo_uploaded?(filename)
          # upload photo
          result = @uploader.upload(file_path)

          photo_id = result.photoid.to_s
          logger.info "Success! (photo_id = #{photo_id}) .. "

          # add photo to set
          add_to_set(@set_name, photo_id)
        else
          logger.info "Skipping, already uploaded! #(photo_id = #{photos_by_name(filename).map(&:photoid).join(' ')})"
        end
      end
    end

    private

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
      logger.info "Creating new set '#{set_name}'"
      @photosets.create(set_name, photo_id)
      find_set(set_name)
    end

    def add_to_set(set_name, photo_id)
      if !@set
        @set = create_set(set_name, photo_id)
      else
        logger.info "Adding to existing set '#{set_name}'"
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
      @logger
    end

  end
end
