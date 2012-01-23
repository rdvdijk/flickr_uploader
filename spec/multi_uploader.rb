require 'spec_helper'

describe FlickrUploader::MultiUploader do

  let(:base_folder_path) { "/fake/path/parent_folder" }

  before do
    @uploader = double(:upload! => nil)
    FlickrUploader::Uploader.stub(:new).and_return(@uploader)

    # Fake a parent older which contains folders with photos
    @parent_dir = double(:to_path => base_folder_path)
    Dir.stub(:chdir).and_yield
  end

  subject do
    FlickrUploader::MultiUploader.new(@parent_dir)
  end

  context "creating sets for every subfolder" do

    let (:subfolders) { [ "folder1", "folder2" ] }

    before do
      Dir.stub(:glob).and_yield(subfolders[0]).and_yield(subfolders[1])
    end

    it "should create new sets for every subfolder" do
      FlickrUploader::Uploader.should_receive(:new).exactly(:twice)

      subject.upload!
    end

    it "should create new sets for the exact folders paths" do
      FlickrUploader::Uploader.should_receive(:new).with("/fake/path/parent_folder/folder1")
      FlickrUploader::Uploader.should_receive(:new).with("/fake/path/parent_folder/folder2")

      subject.upload!
    end

  end

  context "not fail if there are no subfolders" do

    let (:subfolders) { [] }

    before do
      Dir.stub(:glob)
    end

    it "should not create a set" do
      FlickrUploader::Uploader.should_not_receive(:new)

      subject.upload!
    end

  end

end
