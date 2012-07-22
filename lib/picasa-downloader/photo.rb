module PicasaDownloader
  class Photo
    attr_reader :url, :created_date, :size, :name

    def initialize(url, created_date_since_epoch, size, name)
      @url = url
      @created_date = Time.at(created_date_since_epoch)
      @size = size
      @name = name
    end

    def has_video?
      @url.include?'googlevideo'
    end
  end
end
