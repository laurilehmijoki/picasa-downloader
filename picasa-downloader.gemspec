Gem::Specification.new do |s|
  s.name          = 'picasa-downloader'
  s.version       = '0.0.1'
  s.license       = 'MIT'
  s.summary       = 'Download your Google Picasa photo albums'
  s.description   =
    'This Gem makes it convenient to download Picasa albums via command-line interface'
  s.authors       = ['Lauri Lehmijoki']
  s.email         = 'lauri.lehmijoki@iki.fi'
  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.executables   << 'picasa-downloader'
  s.homepage      = 'https://github.com/laurilehmijoki/picasa-downloader'

  s.add_dependency 'require_all'
  if RUBY_VERSION < "1.9"
    s.add_dependency 'gdata'
  else
    s.add_dependency 'gdata_19'
  end
  s.add_dependency 'require_relative'
  s.add_dependency 'nokogiri'
  s.add_dependency 'gli'
  s.add_dependency 'rake'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
