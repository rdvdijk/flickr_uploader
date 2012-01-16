require 'flickr_fu'

module FlickrUploader
  class Uploader

    def all_magic
      folder_path = ARGV[0]
      set_name = File.basename(folder_path)

      @flickr = Flickr.new('flickr.yml')

      uploader = Flickr::Uploader.new(@flickr)

      # Check if the set already exists
      def find_set(name)
        @photosets = Flickr::Photosets.new(@flickr)
        @photosets.get_list.find { |set| set.title == name }
      end

      @set = find_set(set_name)

      # Create set by name
      def create_set(set_name, photo_id)
        if existing_set = find_set(set_name)
          return existing_set
        else
          puts "creating new set '#{set_name}'"
          @photosets.create(set_name, photo_id)
          find_set(set_name)
        end
      end

      # Add a photo to a set, or create new set with it if needed
      def add_to_set(set_name, photo_id)
        if !@set
          @set = create_set(set_name, photo_id)
        else
          puts "adding to existing set '#{set_name}'"
          @set.add_photo(photo_id)
        end
      end

      # loop over all JPG files and upload them
      Dir.chdir(folder_path) do
        Dir.glob("*.jpg") do |file|
          puts "Uploading: #{file}"

          # upload photo
          result = uploader.upload(File.join(folder_path, file))
          photo_id = result.photoid.to_s
          puts "Succesfully uploaded photo ##{photo_id}"

          # add photo to set
          add_to_set(set_name, photo_id)
        end
      end

    end

  end
end
