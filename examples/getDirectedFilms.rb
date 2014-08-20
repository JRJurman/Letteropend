# Usage: ruby getDirectedFilms.rb
# TODO: Allow the user to pass command line arguments

require_relative '../lib/letteropend'

puts 'Looking at films directed by Alfred Hitchcock'

username = 'director'
list = 'alfred-hitchcock'
l = Letteropend::List.new(username, list) do
  on :new_page do
    puts 'pulling data from ' + pages.last
  end
end

puts "There are #{l.films.length} number of films on #{username} #{list}'s list"
