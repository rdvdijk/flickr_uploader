require 'thor'

module FlickrUploader
  class CLI < Thor

    desc "authorize", "Authorize this app with Flickr."
    def authorize
      Authorizer.authorize
    end

    desc "upload [PATH]", "Upload a single folder to Flickr."
    def upload(path)
      folder?(path)
      Uploader.new(path).upload!
    end

    desc "multi-upload [PATH]", "Upload all subfolders of a folder to Flickr."
    def multi_upload(path)
      folder?(path)
      MultiUploader.new(path).upload!
    end

    private

    def folder?(path)
      raise Thor::MalformattedArgumentError.new("Folder '#{path}' does not exist") unless File.exists?(path)
      raise Thor::MalformattedArgumentError.new("'#{path}' is not a folder") unless File.directory?(path)
    end

  end
end
