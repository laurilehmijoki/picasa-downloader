require 'test_helper'

module PicasaDownloader
  describe AlbumPersister do
    before :each do
      VCR.use_cassette("google-login") do
        @client = Client.new(EnvCredentials.new)
        tempdir = ENV['TMPDIR']
        tempdir = '' unless tempdir
        @dir = tempdir + 'picasa-downloader-test'
      end
    end

    after :each do
      FileUtils.rm_r(@dir)
    end

    it "creates a directory for each album" do
      with_cassettes {
        @albums = @client.list_albums
        AlbumPersister.new(@client, @albums.first, @dir).download
        File.exists?(@dir + "/2012/#{@albums.first.title}").should be true
      }
    end

    it "saves each photo into the album" do
      with_cassettes {
        @albums = @client.list_albums
        AlbumPersister.new(@client, @albums.first, @dir).download
        Dir.entries(@dir + "/2012/#{@albums.first.title}/").any? { |file|
          file.downcase.match(/jp(e)?g/)
        }.should be true
      }
    end
  end
end
