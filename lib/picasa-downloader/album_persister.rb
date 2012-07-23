module PicasaDownloader
  class AlbumPersister
    def initialize(client, album, download_directory_root)
      @client = client
      @album = album
      @download_directory_root = download_directory_root
    end

    def download
      FileUtils.mkdir_p(get_temp_album_dir)
      photos = @client.list_photos(@album.id)
      download_and_persist_to_disk(photos)
      move_to_final_dir(photos)
    end

    private

    def download_and_persist_to_disk(photos)
      def persist_to_disk(photo, photo_data)
        File.open(get_temp_album_dir + photo.name, 'wb') { |file|
          file.write(photo_data)
          FileUtils.touch(file.path, :mtime => photo.created_date)
        }
      end
      photos.each { |photo|
        photo_data = @client.download_photo(photo)
        if photo_data
          persist_to_disk(photo, photo_data)
        end
      }
    end

    def move_to_final_dir(photos)
      final_dir = get_final_album_dir_root(PhotoHelper.median_year(photos))
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
