module PicasaDownloader
  class Client
    def initialize(credentials)
      @gd = GData::Client::Photos.new
      @gd.clientlogin(credentials.username, credentials.password)
    end

    def list_albums
      doc = to_xml('https://picasaweb.google.com/data/feed/api/user/default')
      doc.css('entry').map { |e|
        id = e.xpath("id/text()").
          select { |x| x.to_s.match(/^\d+$/) }.
          map { |x| x.inner_text }.first
        Album.new(e.css('title').first.inner_text, id)
      }
    end

    def list_photos(album_id)
      doc = to_xml(
        "https://picasaweb.google.com/data/feed/api/user/default/albumid/#{album_id}?imgmax=d")
      doc.css("entry").map { |e|
        Photo.new(
          e.xpath("group/content/@url").to_s,
          # Google includes the milliseconds in the timestamp:
          e.css("timestamp").inner_text.to_i / 1000,
          e.css("size").inner_text.to_i,
          e.css("title").first.inner_text)
      }
    end

    def download_photo(photo)
      if photo.has_video?
        # Downloading videos is not supported yet
      else
        with_retry {
          uri = URI.parse(photo.url)
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.request_uri)
          http.use_ssl = true
          response = http.request(request)
          raise "Response not ok, was #{response.code}" unless
            response.code.to_i.between? 200, 299
          response.body
        }
      end
    end

    private

    def with_retry
      retries = [3, 5]
      begin
        yield
      rescue Exception
        if delay = retries.shift
          sleep delay
          retry
        else
          raise
        end
      end
    end

    def to_xml(gdata_url)
      response = @gd.get(gdata_url)
      xml = response.to_xml.to_s
      doc = Nokogiri::XML(xml)
      doc.remove_namespaces!
    end
  end
end
