require 'nokogiri'
require 'open-uri'

class List
  attr_reader :films

  def initialize(username, list="films", callbacks)
    @username = username
    @list = list
    @callbacks = callbacks

    @films = []
    @pages = ["/#{username}/#{list}/page/1/"]
    begin
      # get page using Nokogiri
      page = Nokogiri::HTML(open("http://www.letterboxd.com#{@pages.last}"))

      # append visible films to @films
      doc.css(".poster").each do |film|
      end

      # see if there is a next page
      next_page = page.css('.paginate-next')
      if ( next_page.length == 1 )
        @pages.push( next_page[0].attr("href") )
      end
    end while (next_page.length == 1)
  end
end
