require 'thor'
require "colorize"
require "net/http"

module Letteropend
  class CLI < Thor
    desc 'compare_watched_with_watchlist USER1 USER2', ''
    def compare_watched_with_watchlist(user1, user2)
      # print "Films username: "
      # print "Watchlist username: "

      user1_films = Letteropend.get_film_urls(user1, "films")
      user2_watchlist = Letteropend.get_film_urls(user2, "watchlist")

      user2_watchlist.delete_if { |film| !user1_films.include? film }
      puts user2_watchlist
    end

    desc 'compare_watchlist USER1 USER2', ''
    def compare_watchlist(user1, user2)
      # print "First username: "
      # print "Second username: "

      user1_wl = Letteropend.get_film_urls(user1, "watchlist")
      user2_wl = Letteropend.get_film_urls(user2, "watchlist")

      user2_wl.delete_if { |film| !user1_wl.include? film }
      puts user2_wl
    end

    desc 'get_all_time USER', ''
    def get_all_time(user)
      # print "Enter username: "

      urls = Letteropend.get_film_urls(user)
      Letteropend.get_total_minutes(urls)
    end
  end
end
