require "../lib/letteropend/List.rb"

print "Enter username: "
un = gets().chomp
print "Enter list: "
ul = gets().chomp

callbacks = {
  :new_page => lambda{|l| puts "pulling data from #{l.pages.last}"},
  :pulling_film => lambda{|f| puts "pulling data from #{f.url}"}}

l = List.new(un, ul, callbacks)
total = l.get_total_time

puts "Total Runtime: #{total}"
