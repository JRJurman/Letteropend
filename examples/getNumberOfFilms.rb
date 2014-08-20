# Usage: ruby getNumberOfFilms.rb <username> <list>

require_relative '../lib/letteropend'

# Username
un = ARGV[0]

# List
ul = ARGV[1]

Letteropend::List.config do
  on :new_page do
    puts 'Loading ' + pages.last
  end
  on :new_film do
    puts 'Got ' + films.last.url
  end
end

l = Letteropend::List.new(un, ul)

puts "There are #{l.films.length} number of films on #{un}'s #{ul} list"
