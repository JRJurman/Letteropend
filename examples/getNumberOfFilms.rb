require_relative "../lib/letteropend"

print "Enter username: "
un = gets().chomp
print "Enter list: "
ul = gets().chomp

Letteropend::List.config do
  on :new_page do
    puts "Loading "+ pages.last
  end
  on :new_film do
    puts "Got "+films.last.url
  end
end

l = Letteropend::List.new(un, ul)

puts "There are #{l.films.length} number of films on #{un}'s #{ul} list"
