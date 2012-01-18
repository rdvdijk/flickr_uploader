require 'spec_helper'
require 'helpers'

RSpec.configure do |c|
  c.include Helpers
end

describe FlickrUploader::Uploader do

  before do
    # collaborators:
    @set_creator = double
    FlickrUploader::SetCreator.stub(:new).and_return(@set_creator)
  end

  let(:folder_path) { File.join(File.dirname(__FILE__), "example_photoset") }

  subject do
    FlickrUploader::Uploader.new(folder_path)
  end

  context "creating one set" do
    let (:filenames) { filename_list(500) }
    let (:file_paths) { file_paths_list(filenames) }

    before do
      fake_finding_files(filenames)
    end

    it "should create one set if uploading 500 photos or less" do
      # stub
      @set_creator.stub(:upload_files)

      # expectation
      FlickrUploader::SetCreator.should_receive(:new).exactly(:once)

      subject.upload!
    end

    it "should add all photos to one set" do
      # stub
      @set_creator.stub(:upload_files)

      # expectation
      @set_creator.should_receive(:upload_files).with(file_paths)

      subject.upload!
    end
  end

  context "creating multiple sets" do
    let (:filenames) { filename_list(666) }
    let (:file_paths) { file_paths_list(filenames) }

    before do
      fake_finding_files(filenames)
    end

    it "should create multiple sets if uploading more than 500 photos" do
      # stub
      @set_creator.stub(:upload_files)

      # expectation
      FlickrUploader::SetCreator.should_receive(:new).exactly(:twice)

      subject.upload!
    end

    it "should create sets with a 'part N' suffix" do
      # stub
      @set_creator.stub(:upload_files)

      # expectation
      FlickrUploader::SetCreator.should_receive(:new).with("example_photoset (part 1)")
      FlickrUploader::SetCreator.should_receive(:new).with("example_photoset (part 2)")

      subject.upload!
    end

    it "should upload photos in two batches" do
      # stub
      @set_creator.stub(:upload_files)

      # expectation
      @set_creator.should_receive(:upload_files).with(file_paths[0..499])
      @set_creator.should_receive(:upload_files).with(file_paths[500..665])

      subject.upload!
    end
  end

end
