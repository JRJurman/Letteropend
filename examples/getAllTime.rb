require "colorize"
require_relative "../lib/letteropend/List.rb"

print "Enter username: "
un = gets().chomp
print "Enter list: "
ul = gets().chomp

# global variable and function ; yeah I know it's jank
$ct = 0
def pulled_film(film)
  $ct += film.runtime
  puts "Adding ".cyan + film.runtime.to_s.blue.bold + " minutes; Total Minutes: ".cyan + $ct.to_s.blue.bold
  if $ct.to_i < 1440
    print "That's ".cyan + ($ct/60).to_s.blue.bold + " hours and ".cyan + ($ct%60).to_s.blue.bold + " minutes".cyan
  elsif $ct.to_i < 525600
    print "That's ".cyan + ($ct/1440).to_s.blue.bold + " days, ".cyan + ($ct%1440/60).to_s.blue.bold + " hours, and ".cyan + ($ct%1440%60).to_s.blue.bold + " minutes".cyan
  else
    print "That's ".cyan + ($ct/525600).to_s.blue.bold + " years, ".cyan + ($ct%525600/1440).to_s.blue.bold + " days, ".cyan + ($ct%545600%1440/60).to_s.blue.bold + " hours, and ".cyan + ($ct%535600%1440%60).to_s.blue.bold + " minutes".cyan
  end

  puts " -- around ".cyan + ($ct/90).to_s.blue.bold + " movies".cyan
end

callbacks = {
  :new_page => lambda{ |l| puts "pulling data from ".yellow + l.pages.last.magenta.underline},
  :pulling_film => lambda{ |f| puts "pulling data from ".yellow + f.url.blue.underline},
  :pulled_film => lambda{ |f| Object.send(:pulled_film, f) }
}

l = Letteropend::List.new(un, ul, callbacks)
total = l.get_total_time

puts "Total Runtime: #{total}".blue
