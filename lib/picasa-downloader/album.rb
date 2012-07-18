module PicasaDownloader
  class Album
    attr_reader :title, :id

    def initialize(title, id)
      @title = title
      @id = id
    end
  end
end
