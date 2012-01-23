require 'flickr_uploader/configuration'
require 'flickr_uploader/authorizer'
require 'flickr_uploader/cli'
require 'flickr_uploader/set_creator'
require 'flickr_uploader/uploader'
require 'flickr_uploader/multi_uploader'
require 'flickr_uploader/version'
require 'flickr_uploader/progressbar'

module FlickrUploader

  def self.logger
    @logger ||= create_logger
  end

  def self.create_logger
    logger = Logger.new(STDOUT)
    logger.level = Logger::INFO
    logger.formatter = proc do |severity, datetime, progname, msg|
      "[#{severity}][#{datetime.strftime('%H:%M:%S')}] #{msg}\n"
    end
    logger
  end

end
