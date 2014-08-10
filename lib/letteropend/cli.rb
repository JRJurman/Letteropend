require 'thor'
begin
  require "colorize"
rescue LoadError
  puts "we won't judge, but if you want pretty colors, you should totally install colorize"

  class String
    # I can't method missing... halp
    def light_yellow
      self
    end
    def magenta
      self
    end
    def blue
      self
    end
  end
end
require "net/http"

module Letteropend
  class CLI < Thor
    desc 'compare_watched_with_watchlist user1 user2', ''
    def compare_watched_with_watchlist(user1, user2)
      # print "Films username: "
      # print "Watchlist username: "

      user1_films = Letteropend.get_film_urls(user1, "films")
      user2_watchlist = Letteropend.get_film_urls(user2, "watchlist")

      user2_watchlist.delete_if { |film| !user1_films.include? film }
      puts user2_watchlist
    end

    desc 'compare_watchlist user1 user2', ''
    def compare_watchlist(user1, user2)
      # print "First username: "
      # print "Second username: "

      callbacks = {
        :new_page => lambda{ |list| puts "Getting page ".light_yellow + list.pages.length.to_s.magenta + " from ".light_yellow + "#{list.username}'s #{list.list}".magenta }
      }

      user1_wl = List.new(user1, "watchlist", callbacks)
      user2_wl = List.new(user2, "watchlist", callbacks)

      user2_wl.films.delete_if { |film| !user1_wl.films.include? film }
      user2_wl.films.each do |film|
        puts film.title.blue
      end
    end

    desc 'get_all_time user list', ''
    def get_all_time(user, list)
      # print "Enter username: "
      # print "Enter list: "

      callbacks = {
        :new_page => lambda{|l| puts "pulling data from #{l.pages.last}"},
        :pulling_film => lambda{|f| puts "pulling data from #{f.url}"}}

      l = List.new(user, list, callbacks)
      total = l.get_total_time

      puts "Total Runtime: #{total}"
    end
  end
end
