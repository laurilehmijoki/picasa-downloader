module PicasaDownloader
  class PicasaDownloaderError < StandardError
  end

  class EnvironmentalCredentialsNotSet < PicasaDownloaderError
    def initialize(message = 'Cannot authenticate - environmental settings missing. Please set the environmental values PICASA_USERNAME and PICASA_PASSWORD')
      super(message)
    end
  end
end
