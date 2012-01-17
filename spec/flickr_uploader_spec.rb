require 'spec_helper'

describe FlickrUploader::Uploader do

  before do
    @photo_double1 = double
    @photo_double1.stub(:photoid).and_return(42)

    @uploader_double = double
    Flickr::Uploader.stub(:new).and_return(@uploader_double)

    @photosets_double = double
    Flickr::Photosets.stub(:new).and_return(@photosets_double)

    @photoset_double = double
    Flickr::Photosets::Photoset.stub(:new).and_return(@photoset_double)
  end

  let(:folder_path) { File.join(File.dirname(__FILE__), "example_photoset") }

  subject do
    uploader = FlickrUploader::Uploader.new(folder_path)
    uploader.instance_variable_get(:@log).level = Logger::WARN
    uploader
  end

  context "add photo to new set" do

    before do
      @photosets_double.stub(:get_list).and_return([])
    end

    it "should upload a photo" do
      # stubs
      @uploader_double.stub(:upload).and_return(@photo_double1)
      @photosets_double.stub(:create)

      # expectation
      @uploader_double.should_receive(:upload).with(File.join(folder_path, "photo001.jpg"))

      subject.upload!
    end

    it "should create a new set if the set doesn't exist yet" do
      # stubs
      @uploader_double.stub(:upload).and_return(@photo_double1)
      @photosets_double.stub(:create)

      # expectation
      @photosets_double.should_receive(:create).with("example_photoset", "42")

      subject.upload!
    end

    it "should add the photo to a newly created set" do
      # stubs
      @uploader_double.stub(:upload).and_return(@photo_double1)

      @photosets_double.stub(:create).and_return(@photoset_double)
      @photosets_double.stub(:get_list).and_return([@photoset_double])

      @photoset_double.stub(:title).and_return("example_photoset")
      @photoset_double.stub(:get_photos).and_return([])

      # expectation
      @photoset_double.should_receive(:add_photo).at_least(:once).with("42")

      subject.upload!
    end

  end

  context "add photo to existing set" do

    it "should upload a photo" do

    end

    it "should not create a new set" do

    end

    it "should not upload a photo that has already been uploaded in the set" do

    end

  end

end
