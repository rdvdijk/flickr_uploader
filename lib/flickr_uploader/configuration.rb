module FlickrUploader
  module Configuration

    def initialize_flickr
      if File.exists?(configuration_path)
        @flickr = Flickr.new(configuration_path)
      else
        puts "No configuration found in '#{configuration_path}', example content:"
        puts
        puts 'key: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"'
        puts 'secret: "xxxxxxxxxxxxxxxx"'
        puts 'token_cache: "/Users/jane/.flickr-uploader/token_cache.yml"'
        puts

        raise "Missing configuration"
      end
    end

    private

    def configuration_path
      @configuration_path ||= File.join(Dir.home, ".flickr-uploader/flickr.yml")
    end

  end
end
