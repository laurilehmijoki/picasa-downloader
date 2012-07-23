require 'test_helper'

module PicasaDownloader
  describe PhotoHelper do
    it "calculates median year for one photo" do
      photo1 = double('photo')
      photo1.stub('created_date' => Time.utc(2008, 7, 8))
      PhotoHelper.median_year([photo1]).should be 2008
    end

    it "calculates median year for five photos" do
      photo1 = double('photo')
      photo1.stub('created_date' => Time.utc(2000, 7, 8))
      photo2 = double('photo')
      photo2.stub('created_date' => Time.utc(2003, 7, 8))
      photo3 = double('photo')
      photo3.stub('created_date' => Time.utc(2009, 7, 8))
      photo4 = double('photo')
      photo4.stub('created_date' => Time.utc(2010, 7, 8))
      photo5 = double('photo')
      photo5.stub('created_date' => Time.utc(2011, 7, 8))
      PhotoHelper.median_year([photo1, photo2, photo3, photo4, photo5]).should
        be 2009
    end
  end
end
