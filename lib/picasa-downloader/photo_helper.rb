module PicasaDownloader
  class PhotoHelper
    def self.median_year(photos)
      years = photos.map { |photo| photo.created_date.year }
      median = years[years.length / 2]
    end
  end
end
