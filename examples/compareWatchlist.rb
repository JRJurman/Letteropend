require "colorize"
require "net/http"
require "./get_film_urls.rb"

print "First username: "
user1 = gets.chomp

print "Second username: "
user2 = gets.chomp

user1_wl = get_film_urls(user1, "watchlist")
user2_wl = get_film_urls(user2, "watchlist")

user2_wl.delete_if { |film| !user1_wl.include? film }
puts user2_wl
