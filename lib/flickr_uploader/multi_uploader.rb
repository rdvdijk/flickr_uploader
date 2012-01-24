module FlickrUploader
  class MultiUploader

    def initialize(parent_dir, options = {})
      @parent_dir = parent_dir
      @reverse = options[:reverse] == true
    end

    def upload!
      subfolders.each do |subfolder|
        logger.info("Uploading subfolder '#{subfolder}'")
        Uploader.new(File.join(@parent_dir, subfolder)).upload!
      end
    end

    private

    def subfolders
      folders = Dir.chdir(@parent_dir) do
        Dir.glob("*/") || []
      end

      folders.sort { |a,b| (a <=> b) * (@reverse ? -1 : 1) }
    end

    def logger
      FlickrUploader.logger
    end

  end
end
