module PicasaDownloader
  class AlbumPersister
    def initialize(client, album, download_directory_root)
      @client = client
      @album = album
      @download_directory_root = download_directory_root
      FileUtils.mkdir_p(get_album_dir)
    end

    def download
      @client.list_photos(@album.id).each { |photo|
        photo_data = @client.download_photo(photo)
        if photo_data
          File.open(get_album_dir + photo.name, 'wb') { |file|
            file.write(photo_data)
          }
        end
      }
    end

    private

    def get_album_dir
      @download_directory_root + "/#{@album.title}/"
    end
  end
end
