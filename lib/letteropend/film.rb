require "nokogiri"
require "open-uri"

module Letteropend
  class Film
    attr_reader :title, :url, :runtime, :tagline
    def initialize(title, url, callbacks={})
      @title = title
      @url = url
      @pulled = false
      @callbacks = callbacks
    end
  
    def runtime
      if !@pulled
        pull_data
      end
      @runtime
    end

    def tagline
      if !@pulled
        pull_data
      end
      @tagline
    end
  
    def pull_data
      if @callbacks[:pulling_film]
        @callbacks[:pulling_film].call(self)
      end
  
      # pull the page from the url
      page = Nokogiri::HTML(open("http://www.letterboxd.com#{@url}"))
      @pulled = true
  
      # get the runtime for the film
      runtime_cap = page.css(".text-link").text.match(/(\d+) mins/)
      if runtime_cap
        @runtime = runtime_cap.captures[0].to_i
      else
        @runtime = 0
      end

      # get the tagline for the film
      @tagline = page.css(".tagline").text
  
      if @callbacks[:pulled_film]
        @callbacks[:pulled_film].call(self)
      end
    end
  
    def ==(film)
      @title == film.title and @url == film.url
    end
  end
end
