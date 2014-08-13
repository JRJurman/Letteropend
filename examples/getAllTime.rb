require_relative "../lib/letteropend"

print "Enter username: "
un = gets().chomp
print "Enter list: "
ul = gets().chomp

# global variable and function ; yeah I know it's jank
$ct = 0
def pulled_film(film)
  $ct += film.runtime
  puts "Adding #{film.runtime} minutes; Total Minutes: #{$ct}"
  if $ct.to_i < 1440
    puts "That's #{$ct/60} hours and #{$ct%60} minutes"
  elsif $ct.to_i < 525600
    puts "That's #{$ct/1440} days, #{$ct%1440/60} hours, and #{$ct%1440%60} minutes"
  else
    puts "That's #{$ct/525600} years, #{$ct%525600/1440} days, #{$ct%545600%1440/60} hours, and #{$ct%535600%1440%60} minutes"
  end
end

callbacks = {
  :new_page => lambda{ |l| puts "pulling data from {#{l.pages.last}}" },
  :pulling_film => lambda{ |f| puts "pulling data from {#{f.url}}" },
  :pulled_film => lambda{ |f| Object.send(:pulled_film, f) }
}

l = Letteropend::List.new(un, ul, callbacks)
total = l.get_total_time

puts "Total Runtime: #{total} minutes"
