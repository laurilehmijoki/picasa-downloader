module PicasaDownloader
  class AlbumPersister
    def initialize(client, album, download_directory_root)
      @client = client
      @album = album
      @download_directory_root = download_directory_root
    end

    def download
      FileUtils.mkdir_p(get_temp_album_dir)
      @client.list_photos(@album.id).each { |photo|
        photo_data = @client.download_photo(photo)
        if photo_data
          File.open(get_temp_album_dir + photo.name, 'wb') { |file|
            file.write(photo_data)
            FileUtils.touch(file.path, :mtime => photo.created_date)
          }
        end
      }
      move_to_final_dir
    end

    private

    def move_to_final_dir
      file_modified_years = Dir.entries(get_temp_album_dir).map { |file|
        File.new(get_temp_album_dir + file).mtime.year
      }.reject { |year| year == nil }
      album_min_year = file_modified_years.min
      final_dir = get_final_album_dir_root(album_min_year)
      FileUtils.mkdir_p(final_dir)
      FileUtils.mv(get_temp_album_dir, final_dir)
    end

    def get_final_album_dir_root(year)
      @download_directory_root + "/#{year}"
    end

    def get_temp_album_dir
      @download_directory_root + "/.temp/#{@album.title}/"
    end
  end
end
