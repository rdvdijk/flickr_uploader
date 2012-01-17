require 'flickr_fu'
require 'logger'

module FlickrUploader
  class Uploader
    include Configuration

    def initialize(path)
      @log = Logger.new(STDOUT)
      @path = path
      initialize_uploader
    end

    # Loop over all JPG files and upload them to a set.
    def upload!
      Dir.chdir(@path) do
        Dir.glob("*.jpg") do |filename|
          @log.info "Uploading: #{filename} .. "

          unless photo_uploaded?(filename)
            # upload photo
            full_photo_path = File.join(@path, filename)
            result = @uploader.upload(full_photo_path)
            photo_id = result.photoid.to_s
            @log.info "Success! (photo_id = #{photo_id}) .. "

            # add photo to set
            add_to_set(set_name, photo_id)
          else
            @log.info "Skipping, already uploaded! #(photo_id = #{photos_by_name(filename).map(&:photoid).join(' ')})"
          end
        end
      end
    end

    private

    def initialize_uploader
      initialize_flickr
      @uploader = Flickr::Uploader.new(@flickr)

      # Find set, if it exists. This also triggers initial authentication.. (which is needed!)
      @set = find_set(set_name)
    end

    def set_name
      @set_name ||= File.basename(@path)
    end

    def find_set(name)
      @photosets = Flickr::Photosets.new(@flickr)
      @photosets.get_list.find { |set| set.title == name }
    end

    def create_set(set_name, photo_id)
      @log.info "Creating new set '#{set_name}'"
      @photosets.create(set_name, photo_id)
      find_set(set_name)
    end

    def add_to_set(set_name, photo_id)
      if !@set
        @set = create_set(set_name, photo_id)
      else
        @log.info "Adding to existing set '#{set_name}'"
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
  end
end
