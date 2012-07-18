require 'require_relative'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/cassettes"
  config.hook_into :webmock
end

def with_cassettes
  photo_matcher = lambda do |req_1, req_2|
    [req_1, req_2].all? { |req|
      req.uri.include?"googleusercontent"
    }
  end
  VCR.use_cassette("picasa-albums") do
    VCR.use_cassette("picasa-album") do
      VCR.use_cassette("picasa-photo",
                       :match_requests_on => [photo_matcher],
                       :allow_playback_repeats => true) do
        yield
      end
    end
  end
end
