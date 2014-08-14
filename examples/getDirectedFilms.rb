require_relative "../lib/letteropend"


callbacks = {
  :new_page => lambda{ |l| puts "pulling data from " + l.pages.last},
}

puts "Looking at films directed by Alfred Hitchcock"

username = "director"
list = "alfred-hitchcock"
l = Letteropend::List.new(username, list, callbacks)

puts "There are #{l.films.length} number of films on #{username} #{list}'s list"
