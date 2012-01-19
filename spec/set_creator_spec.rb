require 'spec_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe FlickrUploader::SetCreator do

  before do
    # collaborators:
    @uploader = double
    Flickr::Uploader.stub(:new).and_return(@uploader)

    @photosets = double
    Flickr::Photosets.stub(:new).and_return(@photosets)

    @photoset = double
    Flickr::Photosets::Photoset.stub(:new).and_return(@photoset)

    @log_stream = StringIO.new
    FlickrUploader::SetCreator.any_instance.stub(:logger).and_return(Logger.new(@log_stream))

    File.stub(:size).and_return(1024)
  end

  let(:folder_path) { File.join("/some/path", "example_photoset") }

  subject do
    FlickrUploader::SetCreator.new("example_photoset")
  end

  context "add photo to new set" do

    let (:filenames) { filename_list(3) }
    let (:file_paths) { file_paths_list(filenames) }

    before do
      @photosets.stub(:get_list).and_return([])
      stub_multiple_photos(filenames)
    end

    it "should upload a photo" do
      # stubs
      @photosets.stub(:create)

      # expectation
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo001.jpg"))

      subject.upload_files(file_paths)
    end

    it "should upload all photos" do
      # stubs
      @photosets.stub(:create)

      # expectation
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo001.jpg"))
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo002.jpg"))
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo003.jpg"))

      subject.upload_files(file_paths)
    end

    it "should create a new set if the set doesn't exist yet" do
      # stubs
      @photosets.stub(:create)

      # expectation
      @photosets.should_receive(:create).with("example_photoset", "0")

      subject.upload_files(file_paths)
    end

    it "should add the photo to a newly created set" do
      # stubs
      @photosets.stub(:create).and_return(@photoset)
      @photosets.stub(:get_list).and_return([@photoset])

      @photoset.stub(:title).and_return("example_photoset")
      @photoset.stub(:get_photos).and_return([])

      @photoset.stub(:add_photo)

      # expectation
      @photoset.should_receive(:add_photo).at_least(:once).with("0")

      subject.upload_files(file_paths)
    end

  end

  context "add photo to existing set" do

    let (:filenames) { filename_list(3) }
    let (:file_paths) { file_paths_list(filenames) }

    before do
      @photos = stub_multiple_photos(filenames)
      @photosets.stub(:get_list).and_return([@photoset])
      @photoset.stub(:title).and_return("example_photoset")
      @photoset.stub(:get_photos).and_return([@photos.first])
    end

    it "should upload a photo not in the set yet" do
      # stubs
      @photoset.stub(:add_photo)

      # expectation
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo002.jpg"))

      subject.upload_files(file_paths)
    end

    it "should not upload a photo already in the set" do
      @photoset.stub(:add_photo)

      # expectation
      @uploader.should_not_receive(:upload).with(File.join(folder_path, "photo001.jpg"))

      subject.upload_files(file_paths)
    end

    it "should add the remaining photos to the existing set" do
      # stubs
      @photosets.stub(:create)

      # expectation
      @photoset.should_receive(:add_photo).with("1")
      @photoset.should_receive(:add_photo).with("2")

      subject.upload_files(file_paths)
    end

    it "should not create a new set" do
      #stubs
      @photoset.stub(:add_photo)

      @photosets.should_not_receive(:create)
      subject.upload_files(file_paths)
    end

    it "should not upload a photo that has already been uploaded in the set" do
      #stubs
      @photoset.stub(:add_photo)

      # expectation
      @photoset.should_not_receive(:add_photo).with("42")

      subject.upload_files(file_paths)
    end

  end

end
