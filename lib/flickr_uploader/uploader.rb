require 'flickr_fu'

module FlickrUploader
  class Uploader
    include Configuration

    def initialize(path)
      @path = path
      initialize_uploader
    end

    # Loop over all JPG files and upload them to a set.
    def upload!
      Dir.chdir(@path) do
        Dir.glob("*.jpg") do |filename|
          print "Uploading: #{filename} .. "

          if found = photo_uploaded?(filename) and found.empty?
            # upload photo
            full_photo_path = File.join(@path, filename)
            result = @uploader.upload(full_photo_path)
            photo_id = result.photoid.to_s
            print "Success! (photo_id = #{photo_id}) .. "

            # add photo to set
            add_to_set(set_name, photo_id)
          else
            print "Skipping, already uploaded! (photo_id = #{found.map(&:id).join(' ')})"
          end

          puts
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
      puts "Creating new set '#{set_name}'"
      @photosets.create(set_name, photo_id)
      find_set(set_name)
    end

    def add_to_set(set_name, photo_id)
      if !@set
        @set = create_set(set_name, photo_id)
      else
        print "Adding to existing set '#{set_name}'"
        @set.add_photo(photo_id)
      end
    end

    def photo_uploaded?(filename)
      return false unless @set
      @photos ||= @set.get_photos
      base_filename = File.basename(filename, File.extname(filename))
      @photos.select { |photo| photo.title == base_filename }
    end

  end
end
