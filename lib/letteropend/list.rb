require 'nokogiri'
require 'open-uri'
require_relative './film'

module Letteropend
  class List
    attr_reader :username, :list, :films, :pages
    @@valid_events = [:new_page, :new_film]
  
    def initialize(username, list="films", &events) 
      @username = username
      @list = list
  
      @films = []
      @pages = ["/#{username}/#{list}/page/1/"]

      # assign events to list object
      if block_given?
        instance_eval(&events)
      end

      begin
        # get page using Nokogiri
        new_page

        page = Nokogiri::HTML(open("http://www.letterboxd.com#{@pages.last}"))
  
        # append visible films to @films
        page.css(".poster").each do |film|
          title = film.css(".frame-title").text
          url_full = film.css("a")[0].attr("href")
          url = /\/film\/(\S+)\//.match(url_full).captures[0]
          @films.push( Film.new(url, title: title) )
          new_film
        end
  
        # see if there is a next page
        next_page = page.css('a.paginate-next')[0]
        if ( next_page )
          @pages.push( next_page.attr("href") )
        end
      end while ( next_page )
    end

    # Assign events to instance
    #
    # @param event - symbol of event to be triggered
    # @param block - user defined function to be triggered on event
    def on(event, &block)
      if block_given?
        if (@@valid_events.include? event)
          define_singleton_method(event, block)
        else
          puts "Error: trying to assign invalid event | Letteropend::List, event: #{event}"
        end
      end
    end

    # Method to declare class events
    #
    # @param events - block of user defined events
    def self.config(&events)
      if block_given?
        class_eval(&events)
      end
    end

    # Assign events to class
    #
    # @param event - symbol of event to be triggered
    # @param block - user defined function to be triggered on event
    def self.on(event, &block)
      if block_given?
        if (@@valid_events.include? event)
          define_method(event, block)
        else
          puts "Error: trying to assign invalid class event | Letteropend::List, event: #{event}"
        end
      end
    end

    def get_total_time
      total_runtime = 0
      @films.each do |film|
        total_runtime += film.runtime
      end
      return total_runtime
    end

    def method_missing(sym, *args)
      if (@@valid_events.include? sym)
        # no method was defined for this event
      else
        super
      end
    end
  
  end
end
