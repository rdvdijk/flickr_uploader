require 'spec_helper'

module FlickrUploader
  describe CLI do

    describe "#authorize" do

      it "authorizes" do
        Authorizer.should_receive(:authorize!)
        subject.authorize
      end

    end

    describe "#upload" do

      it "uploads existing folders" do
        uploader = double
        uploader.should_receive(:upload!)

        Uploader.stub(:new).and_return(uploader)
        Uploader.should_receive(:new)

        File.stub(:exists?).and_return(true)
        File.stub(:directory?).and_return(true)

        subject.upload("/existing/path")
      end

      it "does not upload non-existing folders" do
        uploader = double
        uploader.should_not_receive(:upload!)

        Uploader.stub(:new).and_return(uploader)
        Uploader.should_not_receive(:new)

        File.stub(:exists?).and_return(false)

        expect { subject.upload("/existing/path") }.to raise_error(Thor::MalformattedArgumentError)
      end

      it "does not upload single files" do
        uploader = double
        uploader.should_not_receive(:upload!)

        Uploader.stub(:new).and_return(uploader)
        Uploader.should_not_receive(:new)

        File.stub(:exists?).and_return(true)
        File.stub(:directory?).and_return(false)

        expect { subject.upload("/existing/path") }.to raise_error(Thor::MalformattedArgumentError)
      end

    end

    describe "#multi_upload" do

      it "uploads existing folders" do
        multi_uploader = double
        multi_uploader.should_receive(:upload!)

        MultiUploader.stub(:new).and_return(multi_uploader)
        MultiUploader.should_receive(:new)

        File.stub(:exists?).and_return(true)
        File.stub(:directory?).and_return(true)

        subject.multi_upload("/existing/path")
      end

      it "does not upload non-existing folders" do
        multi_uploader = double
        multi_uploader.should_not_receive(:upload!)

        MultiUploader.stub(:new).and_return(multi_uploader)
        MultiUploader.should_not_receive(:new)

        File.stub(:exists?).and_return(false)

        expect { subject.multi_upload("/existing/path") }.to raise_error(Thor::MalformattedArgumentError)
      end

      it "does not upload single files" do
        multi_uploader = double
        multi_uploader.should_not_receive(:upload!)

        MultiUploader.stub(:new).and_return(multi_uploader)
        MultiUploader.should_not_receive(:new)

        File.stub(:exists?).and_return(true)
        File.stub(:directory?).and_return(false)

        expect { subject.multi_upload("/existing/path") }.to raise_error(Thor::MalformattedArgumentError)
      end

    end

  end
end

