require 'spec_helper'

describe FlickrUploader::Uploader do

  before do
    # collaborators:
    @uploader = double
    Flickr::Uploader.stub(:new).and_return(@uploader)

    @photosets = double
    Flickr::Photosets.stub(:new).and_return(@photosets)

    @photoset = double
    Flickr::Photosets::Photoset.stub(:new).and_return(@photoset)

    # photos being uploaded:
    @photo1 = create_photo(42, "photo001")
    @photo2 = create_photo(43, "photo002")
    @photo3 = create_photo(44, "photo003")
  end

  let(:folder_path) { File.join(File.dirname(__FILE__), "example_photoset") }

  subject do
    uploader = FlickrUploader::Uploader.new(folder_path)
    uploader.instance_variable_get(:@log).level = Logger::WARN # is there a better way to do this?
    uploader
  end

  context "add photo to new set" do

    before do
      @photosets.stub(:get_list).and_return([])
    end

    it "should upload a photo" do
      # stubs
      @photosets.stub(:create)

      # expectation
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo001.jpg"))

      subject.upload!
    end

    it "should upload all photos" do
      # stubs
      @photosets.stub(:create)

      # expectation
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo001.jpg"))
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo002.jpg"))
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo003.jpg"))

      subject.upload!
    end

    it "should create a new set if the set doesn't exist yet" do
      # stubs
      @photosets.stub(:create)

      # expectation
      @photosets.should_receive(:create).with("example_photoset", "42")

      subject.upload!
    end

    it "should add the photo to a newly created set" do
      # stubs
      @photosets.stub(:create).and_return(@photoset)
      @photosets.stub(:get_list).and_return([@photoset])

      @photoset.stub(:title).and_return("example_photoset")
      @photoset.stub(:get_photos).and_return([])

      @photoset.stub(:add_photo)

      # expectation
      @photoset.should_receive(:add_photo).at_least(:once).with("42")

      subject.upload!
    end

  end

  context "add photo to existing set" do

    before do
      @photosets.stub(:get_list).and_return([@photoset])
      @photoset.stub(:title).and_return("example_photoset")
      @photoset.stub(:get_photos).and_return([@photo1])
    end

    it "should upload a photo not in the set yet" do
      # stubs
      @photoset.stub(:add_photo)

      # expectation
      @uploader.should_receive(:upload).with(File.join(folder_path, "photo002.jpg"))

      subject.upload!
    end

    it "should not upload a photo already in the set" do
      @photoset.stub(:add_photo)

      # expectation
      @uploader.should_not_receive(:upload).with(File.join(folder_path, "photo001.jpg"))

      subject.upload!
    end

    it "should add the remaining photos to the existing set" do
      # stubs
      @photosets.stub(:create)

      # expectation
      @photoset.should_receive(:add_photo).with("43")
      @photoset.should_receive(:add_photo).with("44")

      subject.upload!
    end

    it "should not create a new set" do
      #stubs
      @photoset.stub(:add_photo)

      @photosets.should_not_receive(:create)
      subject.upload!
    end

    it "should not upload a photo that has already been uploaded in the set" do
      #stubs
      @photoset.stub(:add_photo)

      # expectation
      @photoset.should_not_receive(:add_photo).with("42")

      subject.upload!
    end

  end

  private

  def create_photo(id, title)
    photo = double
    photo.stub(:photoid).and_return(id)
    photo.stub(:title).and_return(title)
    @uploader.stub(:upload).with(File.join(folder_path, "#{title}.jpg")).and_return(photo)
    photo
  end

end
