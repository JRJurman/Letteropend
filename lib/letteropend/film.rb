require "nokogiri"
require "open-uri"

module Letteropend
  class Film
    def initialize(url, details={}, callbacks={})
      @url = url
      @pulled = false

      details.each do |key, value|
        define_singleton_method(key, lambda{value})
      end
      @callbacks = callbacks
    end

    def pull_data
      if @callbacks[:pulling_film]
        @callbacks[:pulling_film].call(self)
      end
  
      # pull the page from the url
      page = Nokogiri::HTML(open("http://www.letterboxd.com#{@url}"))
      @pulled = true
  
      # get the title for the film
      title = page.css("h1.film-title").text
      define_singleton_method(:title, lambda{title})

      # get the runtime for the film
      runtime_cap = page.css(".text-link").text.match(/(\d+) mins/)
      if runtime_cap
        runtime = runtime_cap.captures[0].to_i
      else
        runtime = 0
      end
      define_singleton_method(:runtime, lambda{runtime})

      # get the tagline for the film
      tagline = page.css(".tagline").text
      define_singleton_method(:tagline, lambda{tagline})

      # get the overview for the film
      overview = page.css("div.truncate").text.strip
      define_singleton_method(:overview, lambda{overview})
  
      if @callbacks[:pulled_film]
        @callbacks[:pulled_film].call(self)
      end
    end
  
    def ==(film)
      @url == film.url
    end

    def method_missing(sym, *args)
      if ([:title, :tagline, :overview, :runtime].include? sym) and !@pulled
        pull_data
        self.send(sym)
      else
        super
      end
    end

  end
end
