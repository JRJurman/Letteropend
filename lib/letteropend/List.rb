require 'nokogiri'
require 'open-uri'
require_relative './Film.rb'

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
        @films.push( Film.new(title, url) )
        if callbacks[:new_film]
          callbacks[:new_film].call(self)
        end
      end

      # see if there is a next page
      next_page = page.css('.paginate-next')[0].attr("href")
      if ( next_page )
        @pages.push( next_page )
      end
    end while ( next_page )
  end
end
