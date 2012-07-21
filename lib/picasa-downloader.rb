def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end
require 'rubygems'
require 'fileutils'
require_all 'picasa-downloader'
require 'gdata'
require 'nokogiri'
require 'net/http'
require 'uri'
