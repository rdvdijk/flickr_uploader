require 'flickr_fu'

module FlickrUploader
  class Authorizer
    def authorize
      flickr = Flickr.new('flickr.yml')

      puts "Visit the following url, then click <enter> once you have authorized:"

      # request write permissions
      puts
      puts flickr.auth.url(:write)
      puts

      gets

      flickr.auth.cache_token
    end
  end
end
