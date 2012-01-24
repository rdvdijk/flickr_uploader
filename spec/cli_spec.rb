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

        CLI.start(["upload", "/existing/path"])
      end

      it "does not upload non-existing folders" do
        uploader = double
        uploader.should_not_receive(:upload!)

        Uploader.stub(:new).and_return(uploader)
        Uploader.should_not_receive(:new)

        File.stub(:exists?).and_return(false)

        capture(:stderr) { CLI.start(["upload", "/existing/path"]) }.should =~ /Folder '\/existing\/path' does not exist/
      end

      it "does not upload single files" do
        uploader = double
        uploader.should_not_receive(:upload!)

        Uploader.stub(:new).and_return(uploader)
        Uploader.should_not_receive(:new)

        File.stub(:exists?).and_return(true)
        File.stub(:directory?).and_return(false)

        capture(:stderr) { CLI.start(["upload", "/existing/path"]) }.should =~ /'\/existing\/path' is not a folder/
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

        CLI.start(["multi-upload", "/existing/path"])
      end

      it "does not upload non-existing folders" do
        multi_uploader = double
        multi_uploader.should_not_receive(:upload!)

        MultiUploader.stub(:new).and_return(multi_uploader)
        MultiUploader.should_not_receive(:new)

        File.stub(:exists?).and_return(false)

        capture(:stderr) { CLI.start(["multi-upload", "/existing/path"]) }.should =~ /Folder '\/existing\/path' does not exist/
      end

      it "does not upload single files" do
        multi_uploader = double
        multi_uploader.should_not_receive(:upload!)

        MultiUploader.stub(:new).and_return(multi_uploader)
        MultiUploader.should_not_receive(:new)

        File.stub(:exists?).and_return(true)
        File.stub(:directory?).and_return(false)

        capture(:stderr) { CLI.start(["multi-upload", "/existing/path"]) }.should =~ /'\/existing\/path' is not a folder/
      end

    end

    describe "#multi_upload, reversed" do

      it "uploads in reverse order if asked to" do
        multi_uploader = double
        multi_uploader.should_receive(:upload!)

        MultiUploader.stub(:new).and_return(multi_uploader)
        MultiUploader.should_receive(:new).with("/existing/path", { :reverse => true })

        File.stub(:exists?).and_return(true)
        File.stub(:directory?).and_return(true)

        CLI.start(["multi-upload", "/existing/path", "--reverse"])
      end

      it "uploads in regular order if not asked to sort in reverse order" do
        multi_uploader = double
        multi_uploader.should_receive(:upload!)

        MultiUploader.stub(:new).and_return(multi_uploader)
        MultiUploader.should_receive(:new).with("/existing/path", { :reverse => false })

        File.stub(:exists?).and_return(true)
        File.stub(:directory?).and_return(true)

        CLI.start(["multi-upload", "/existing/path"])
      end

    end

  end
end

