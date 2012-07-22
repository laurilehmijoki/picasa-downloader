require 'vcr'
require_relative 'test_helper'
require_relative '../lib/picasa-downloader'

module PicasaDownloader
  describe Client do
    before :each do
      VCR.use_cassette("google-login") do
        @client = Client.new(EnvCredentials.new())
      end
    end

    it "loads the album ids" do
      VCR.use_cassette("picasa-albums") do
        albums = @client.list_albums
        albums.length.should be > 0
        albums.first.id =~ /^\d+$/
        albums.first.title.length.should be > 0
      end
    end

    it "lists photos for an album" do
      VCR.use_cassette("picasa-albums") do
        @albums = @client.list_albums
      end
      VCR.use_cassette("picasa-album") do
        photos = @client.list_photos(@albums.first.id)
        photos.length.should be > 0
        photos.first.url =~ /^https/
        photos.first.created_date.should be < Time.new
        photos.first.created_date.should be > Time.at(0)
        photos.first.size.should be > 0
        photos.first.name.length.should be > 0
      end
    end

    it "downloads photos photos of an album" do
      with_cassettes {
        albums = @client.list_albums
        photos = @client.list_photos(albums.first.id)
        def jpeg?(data)
          # See http://www.astro.keele.ac.uk/oldusers/rno/Computing/File_magic.html
          return data[0, 4] == "\xff\xd8\xff\xe0"
        end
        bytes = @client.download_photo(photos.first)
        jpeg?(bytes).should be true
      }
    end
  end
end
