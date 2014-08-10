class Film
  attr_reader :title, :url
  def initialize(title, url)
    @title = title
    @url = url
  end

  def ==(film)
    @title == film.title and @url == film.url
  end
end
