require 'flickr_fu'
require 'logger'

module FlickrUploader
  class Uploader

    PHOTOSET_LIMIT = 500 # Flickr limit, not mine

    def initialize(path)
      @logger = Logger.new(STDOUT)
      @path = path
    end

    # create photosets of 500 or less photos
    def upload!
      if photo_paths.size > PHOTOSET_LIMIT
        photo_paths.each_slice(PHOTOSET_LIMIT).with_index do |photo_paths_subset, index|
          create_set(base_set_name + " (part #{index+1})", photo_paths_subset)
        end
      else
        create_set(base_set_name, photo_paths)
      end
    end

    private

    def create_set(name, photo_paths)
      set_creator = SetCreator.new(name)
      set_creator.upload_files(photo_paths)
    end

    def photo_paths
      @photo_paths ||= filenames.map { |f| File.join(@path, f) }
    end

    def filenames
      Dir.chdir(@path) do
        Dir.glob("*.jpg")
      end
    end

    def base_set_name
      @base_set_name ||= File.basename(@path)
    end

  end
end
