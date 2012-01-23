require 'flickr_fu'
require 'readline'

module FlickrUploader
  class Authorizer
    extend Configuration

    def self.authorize!
      initialize_flickr

      puts "Visit the following url, then press <enter> once you have authorized:"

      # request write permissions
      puts
      puts @flickr.auth.url(:write)
      puts

      # wait for input .. ('gets' doesn't work..?)
      line = Readline.readline("press <enter> when done ...")

      @flickr.auth.cache_token
    end
  end
end
