require "nokogiri"
require "open-uri"

module Letteropend
  # The Film class
  class Film
    attr_reader :url
    @@valid_attributes = [:title, :tagline, :overview, :runtime]
    @@valid_events = [:model_updated, :model_updating]

    # Creates a new film instance
    #
    # @param url - the url letterboxd assigns the film
    # @param details - the attributes the user assigns the film (instead of pulling from letterboxd)
    # @param events - block of user defined events
    def initialize(url, *details, &events)
      @url = url
      @pulled = false
      @pulling = false
      @events = {}

      # assign each detail to a method
      details.each do |detail|
        detail.each do |key, value|

          # only assign valid attributes to a film
          if @@valid_attributes.include? key
            define_singleton_method(key, lambda{value})
          else
            puts "Error: trying to assign invalid film data | film: #{@url}, attribute: #{key}"
          end

        end
      end

      # assign events to film object
      if block_given?
        instance_eval(&events)
      end
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
          puts "Error: trying to assign invalid event | Letteropend::Film, event: #{event}"
        end
      end
    end

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
          puts "Error: trying to assign invalid class event | Letteropend::Film, event: #{event}"
        end
      end
    end

    def pull_data
      @pulling = true

      model_updating

      # pull the page from the url
      page = Nokogiri::HTML(open("http://www.letterboxd.com/film/#{@url}/"))
  
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
  
      @pulled = true
      @pulling = false

      model_updated
    end
  
    def ==(film)
      @url == film.url
    end

    def method_missing(sym, *args)
      if (@@valid_attributes.include? sym)
        if !@pulled and !@pulling
          pull_data
          self.send(sym)
        elsif !@pulled and @pulling
          puts "Error: trying to get film data prematurely | film: #{@url}, method: #{sym}"
        end
      elsif (@@valid_events.include? sym)
        # no method was defined for this event
      else
        super
      end
    end

  end
end
