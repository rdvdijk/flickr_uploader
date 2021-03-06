module Helpers

  def create_photo(id, title)
    photo = double
    photo.stub(:id).and_return(id)
    photo.stub(:title).and_return(title)
    if @uploader
      xml = double("xml", :photoid => id)
      @uploader.stub(:upload).with(File.join(folder_path, "#{title}.jpg")).and_return(xml)
    end
    photo
  end

  def filename_list(size)
    (1..size).map { |n| "photo" + ("%03d" % n) + ".jpg" }
  end

  def file_paths_list(list)
    list.map do |filename|
      File.join(folder_path, filename)
    end
  end

  def stub_multiple_photos(list)
    photos = []
    list.each_with_index do |filename, index|
      title = File.basename(filename, File.extname(filename))
      photos << create_photo(index, title)
    end
    photos
  end

  def fake_finding_files(filenames, filepaths)
    # puts "stubbing glob with #{list.size} files: #{list}"
    Dir.stub(:glob).and_return(filenames)
    Dir.stub(:chdir).and_yield
  end

  # Borrowed from wycats's Thor spec_helper.rb:
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end

end
