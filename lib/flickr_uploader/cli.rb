require 'thor'

module FlickrUploader
  class CLI < Thor

    desc "authorize", "Authorize this app with Flickr."
    def authorize
      Authorizer.authorize
    end

    desc "upload [PATH]", "Upload a folder to Flickr."
    def upload(path)
      raise Thor::MalformattedArgumentError.new("Folder '#{path}' does not exist") unless File.exists?(path)
      raise Thor::MalformattedArgumentError.new("'#{path}' is not a folder") unless File.directory?(path)

      Uploader.new(path).upload!
    end

  end
end
