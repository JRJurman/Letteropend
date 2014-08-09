require 'net/http'
require 'colorize'
require './get_film_urls.rb'
require './get_total_minutes.rb'

print "Enter username: "
un = gets().chomp
urls = get_film_urls(un)
get_total_minutes(urls)
