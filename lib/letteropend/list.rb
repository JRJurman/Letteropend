require 'nokogiri'
require 'open-uri'
require_relative './film'

module Letteropend
  # The List class
  class List
    attr_reader :username, :list, :films, :pages
    VALID_EVENTS = [:new_page, :new_film]

    # Created a new list instance
    #
    # @param username - the username for the list
    # @param list - name of list, defaults to "films" (watched movies)
    # @param events - block of user defined events
    def initialize(username, list = 'films', &events)
      @username = username
      @list = list

      @films = []
      @pages = ["/#{username}/#{list}/page/1/"]

      # assign events to list object
      instance_eval(&events) if block_given?

      loop do
        # get page using Nokogiri
        new_page

        page = Nokogiri::HTML(open("http://www.letterboxd.com#{@pages.last}"))

        # append visible films to @films
        page.css('.poster').each do |film|
          title = film.css('.frame-title').text
          url_full = film.css('a')[0].attr('href')
          url = %r{/film/(\S+)/}.match(url_full).captures[0]
          @films.push(Film.new(url, title: title))
          new_film
        end

        # see if there is a next page
        next_page = page.css('a.paginate-next')[0]
        if next_page
          @pages.push(next_page.attr('href'))
        else
          break
        end
      end
    end

    # Assign events to instance
    #
    # @param event - symbol of event to be triggered
    # @param block - user defined function to be triggered on event
    def on(event, &block)
      return unless block_given?

      if VALID_EVENTS.include? event
        define_singleton_method(event, block)
      else
        puts "Error: trying to assign invalid event | Letteropend::List, event: #{event}"
      end
    end

    # Method to declare class events
    #
    # @param events - block of user defined events
    def self.config(&events)
      class_eval(&events) if block_given?
    end

    # Assign events to class
    #
    # @param event - symbol of event to be triggered
    # @param block - user defined function to be triggered on event
    def self.on(event, &block)
      return unless block_given?

      if VALID_EVENTS.include? event
        define_method(event, block)
      else
        puts "Error: trying to assign invalid class event | Letteropend::List, event: #{event}"
      end
    end

    def method_missing(sym, *args)
      return unless VALID_EVENTS.include? sym # return if no method was defined for this event

      super
    end
  end
end
