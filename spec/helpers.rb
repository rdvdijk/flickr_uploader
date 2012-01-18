module Helpers

  def create_photo(id, title)
    photo = double
    photo.stub(:photoid).and_return(id)
    photo.stub(:title).and_return(title)
    if @uploader
      @uploader.stub(:upload).with(File.join(folder_path, "#{title}.jpg")).and_return(photo)
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

  def fake_finding_files(list)
    # puts "stubbing glob with #{list.size} files: #{list}"
    Dir.stub(:glob).and_return(list)
  end

end
