require 'test_helper'
require_relative '../lib/picasa-downloader'

module PicasaDownloader
  describe EnvCredentials do
    it "knows when the credentials are not set" do
      ENV['PICASA_USERNAME'] = ''
      ENV['PICASA_PASSWORD'] = ''
      creds = EnvCredentials.new
      creds.is_configured?.should be false
    end

    it "knows when the credentials are set" do
      ENV['PICASA_USERNAME'] = 'uzer'
      ENV['PICASA_PASSWORD'] = 'pazz'
      creds = EnvCredentials.new
      creds.is_configured?.should be true
    end
  end
end
