require_relative "../lib/letteropend"

print "Enter username: "
un = gets().chomp
print "Enter list: "
ul = gets().chomp

callbacks = {
  :new_page => lambda{ |l| puts "pulling data from " + l.pages.last},
}

l = Letteropend::List.new(un, ul, callbacks)

puts "There are #{l.films.length} number of films on #{un}'s #{ul} list"
