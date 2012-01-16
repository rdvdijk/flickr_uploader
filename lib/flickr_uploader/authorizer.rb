require 'flickr_fu'
require 'readline'

module FlickrUploader
  class Authorizer
    def self.authorize
      flickr = Flickr.new('flickr.yml')

      puts "Visit the following url, then click <enter> once you have authorized:"

      # request write permissions
      puts
      puts flickr.auth.url(:write)
      puts

      # wait for input .. (gets doesn't work..?)
      line = Readline.readline("..")

      flickr.auth.cache_token
    end
  end
end
