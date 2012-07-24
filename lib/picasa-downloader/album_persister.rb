module PicasaDownloader
  class AlbumPersister
    def initialize(client, album, download_directory_root)
      @client = client
      @album = album
      @download_directory_root = download_directory_root
    end

    def download
      photos = @client.list_photos(@album.id)
      target_dir = create_dir(photos)
      download_and_persist_to_disk(photos, target_dir)
    end

    private

    def create_dir(photos)
      median_year = PhotoHelper.median_year(photos)
      target_dir = get_final_album_dir(median_year, @album.title)
      FileUtils.mkdir_p(target_dir) unless File.exists? target_dir
      target_dir
    end

    def download_and_persist_to_disk(photos, target_dir)
      photos.each { |photo|
        photo_data = @client.download_photo(photo)
        if photo_data
          persist_to_disk(photo, photo_data, target_dir)
        end
      }
    end

    def persist_to_disk(photo, photo_data, target_dir)
      File.open(target_dir + photo.name, 'wb') { |file|
        file.write(photo_data)
        FileUtils.touch(file.path, :mtime => photo.created_date)
      }
    end

    def get_final_album_dir(year, title)
      @download_directory_root + "/#{year}/#{title}/"
    end
  end
end
