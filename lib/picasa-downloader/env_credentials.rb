module PicasaDownloader
  class EnvCredentials
    attr_reader :username, :password

    def initialize
      @username = ENV['PICASA_USERNAME']
      @password = ENV['PICASA_PASSWORD']
    end

    def is_configured?
      ENV['PICASA_USERNAME'].to_s != '' &&
      ENV['PICASA_PASSWORD'].to_s != ''
    end
  end
end
