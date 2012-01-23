module FlickrUploader
  class MultiUploader

    def initialize(parent_dir)
      @parent_dir = parent_dir
    end

    def upload!
      Dir.chdir(@parent_dir) do
        Dir.glob("*/") do |subfolder|
          Uploader.new(File.join(@parent_dir, subfolder)).upload!
        end
      end
    end

  end
end
