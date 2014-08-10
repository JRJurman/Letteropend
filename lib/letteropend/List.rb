require 'nokogiri'
require 'open-uri'
require_relative './Film'

class List
  attr_reader :username, :list, :films, :pages

  def initialize(username, list="films", callbacks={})
    @username = username
    @list = list

    @films = []
    @pages = ["/#{username}/#{list}/page/1/"]
    begin
      # get page using Nokogiri
      if callbacks[:new_page]
        callbacks[:new_page].call(self)
      end
      page = Nokogiri::HTML(open("http://www.letterboxd.com#{@pages.last}"))

      # append visible films to @films
      page.css(".poster").each do |film|
        title = film.css(".frame-title").text
        url = film.css("a")[0].attr("href")
        @films.push( Film.new(title, url, callbacks) )
        if callbacks[:new_film]
          callbacks[:new_film].call(self)
        end
      end

      # see if there is a next page
      next_page = page.css('.paginate-next')[0]
      if ( next_page )
        @pages.push( next_page.attr("href") )
      end
    end while ( next_page )
  end
  
  def get_total_time
    total_runtime = 0
    @films.each do |film|
      puts film.runtime
      total_runtime += film.runtime
    end
    return total_runtime
  end

end
