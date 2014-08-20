# Usage: ruby getAllTime.rb <username> <list>

require_relative "../lib/letteropend"

# Username
un = ARGV[0]

# List
ul = ARGV[1]

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

Letteropend::Film.config do
  on :model_updating do
    puts "pulling data from {#{url}}"
  end
  on :model_updated do
    Object.send(:pulled_film, self)
  end
end

l = Letteropend::List.new(un, ul) do 
  on :new_page do
    puts "pulling data from {#{pages.last}}"
  end
end

total = 0
l.films.each do |film|
  total += film.runtime
end

puts "Total Runtime: #{total} minutes"
