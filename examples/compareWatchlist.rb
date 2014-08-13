# This example requires colorize
require "colorize"
require_relative "../lib/letteropend"

callbacks = {
  :new_page => lambda{ |list| puts "Getting page ".light_yellow + list.pages.length.to_s.magenta + " from ".light_yellow + "#{list.username}'s #{list.list}".magenta }
}
print "First username: "
user1 = gets.chomp

print "Second username: "
user2 = gets.chomp

user1_wl = Letteropend::List.new(user1, "watchlist", callbacks)
user2_wl = Letteropend::List.new(user2, "watchlist", callbacks)

user2_wl.films.delete_if { |film| !user1_wl.films.include? film }
user2_wl.films.each do |film|
  puts film.title.blue
end
