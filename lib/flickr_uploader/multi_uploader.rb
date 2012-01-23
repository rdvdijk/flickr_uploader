module FlickrUploader
  class MultiUploader

    def initialize(parent_dir)
      @parent_dir = parent_dir
    end

    def upload!
      subfolders.sort.each do |subfolder|
        logger.info("Uploading subfolder '#{subfolder}'")
        Uploader.new(File.join(@parent_dir, subfolder)).upload!
      end
    end

    private

    def subfolders
      Dir.chdir(@parent_dir) do
        Dir.glob("*/") || []
      end
    end

    def logger
      FlickrUploader.logger
    end

  end
end
