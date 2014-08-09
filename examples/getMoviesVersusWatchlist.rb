require "colorize"
require "net/http"
require "./get_film_urls.rb"

print "Films username: "
user1 = gets.chomp

print "Watchlist username: "
user2 = gets.chomp

user1_films = get_film_urls(user1, "films")
user2_watchlist = get_film_urls(user2, "watchlist")

user2_watchlist.delete_if { |film| !user1_films.include? film }
puts user2_watchlist
