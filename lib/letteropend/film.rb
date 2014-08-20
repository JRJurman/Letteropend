require 'nokogiri'
require 'open-uri'

module Letteropend
  # The Film class
  class Film
    attr_reader :slug, :url
    VALID_ATTRIBUTES = [:title, :tagline, :overview, :runtime]
    VALID_EVENTS = [:model_updated, :model_updating]

    # Creates a new film instance
    #
    # @param id - the title letterboxd assigns the film for the url
    # @param details - the attributes the user assigns the film (instead of
    #   pulling from letterboxd)
    # @param events - block of user defined events
    def initialize(slug, details = {}, &events)
      @slug = slug.split('/').last
      @url = "http://letterboxd.com/film/#{@slug}/"
      @pulled = false
      @pulling = false
      @events = {}

      # assign each detail to a method
      details.each do |key, value|

        # only assign valid attributes to a film
        if VALID_ATTRIBUTES.include? key
          define_singleton_method(key, -> { value })
        else
          puts "Error: trying to assign invalid film data | film: #{@slug}, " \
               "attribute: #{key}"
        end

      end

      # assign events to film object
      instance_eval(&events) if block_given?
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
        puts 'Error: trying to assign invalid event | Letteropend::Film, ' \
             "event: #{event}"
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
      if block_given?
        if VALID_EVENTS.include? event
          define_method(event, block)
        else
          puts 'Error: trying to assign invalid class event | ' \
               "Letteropend::Film, event: #{event}"
        end
      end
    end

    # Goes to Letterboxd and pulls html page with nokogiri
    def pull_data
      @pulling = true

      model_updating

      # pull the page from the url
      page = Nokogiri::HTML(open(@url))

      # get the title for the film
      title = page.css('h1.film-title').text
      define_singleton_method(:title, -> { title })

      # get the runtime for the film
      runtime_cap = page.css('.text-link').text.match(/(\d+) mins/)
      if runtime_cap
        runtime = runtime_cap.captures[0].to_i
      else
        runtime = 0
      end
      define_singleton_method(:runtime, -> { runtime })

      # get the tagline for the film
      tagline = page.css('.tagline').text
      define_singleton_method(:tagline, -> { tagline })

      # get the overview for the film
      overview = page.css('div.truncate').text.strip
      define_singleton_method(:overview, -> { overview })

      @pulled = true
      @pulling = false

      model_updated
    end

    # Equivalence operator
    def ==(other)
      @slug == other.slug
    end

    # Method Missing implementation
    #
    # @param sym - method trying to be called
    # @param args - arguments passed into the method call
    def method_missing(sym, *args)
      if VALID_ATTRIBUTES.include? sym
        if !@pulled && !@pulling
          pull_data
          send(sym)
        elsif !@pulled && @pulling
          puts "Error: trying to get film data prematurely | film: #{@slug}, " \
               "method: #{sym}"
        end
      elsif VALID_EVENTS.include? sym
        # no method was defined for this event
      else
        super
      end
    end
  end
end
