require 'thor'

module FlickrUploader
  class CLI < Thor

    desc "authorize", "Authorize this app with Flickr."
    def authorize
      Authorizer.authorize!
    end

    desc "upload [PATH]", "Upload a single folder to Flickr."
    method_option :verbose, :type => :boolean, :aliases => "-v", :desc => "Show more logging."
    def upload(path)
      handle_options(path, options)
      Uploader.new(path).upload!
    end

    desc "multi-upload [PATH]", "Upload all subfolders of a folder to Flickr."
    method_option :verbose, :type => :boolean, :aliases => "-v", :desc => "Show more logging."
    method_option :reverse, :type => :boolean, :aliases => "-r", :desc => "Upload subfolders in reverse order."
    def multi_upload(path)
      handle_options(path, options)
      MultiUploader.new(path, uploader_options(options)).upload!
    end

    private

    def handle_options(path, options)
      folder?(path)
      verbose_logger if options[:verbose]
    end

    def uploader_options(options)
      { :reverse => (options[:reverse] == true) }
    end

    def folder?(path)
      raise Thor::MalformattedArgumentError.new("Folder '#{path}' does not exist") unless File.exists?(path)
      raise Thor::MalformattedArgumentError.new("'#{path}' is not a folder") unless File.directory?(path)
    end

    def verbose_logger
      FlickrUploader.logger.level = Logger::DEBUG
    end

  end
end
