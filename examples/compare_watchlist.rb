# Usage: ruby compare_watchlist.rb <username 1> <username 2>

require_relative '../lib/letteropend'

Letteropend::List.config do
  on :new_page do
    puts "Getting page {#{pages.length}} from #{username}'s #{list}"
  end
end

# First username
user1 = ARGV[0]

# Second username
user2 = ARGV[1]

user1_wl = Letteropend::List.new(user1, 'watchlist')
user2_wl = Letteropend::List.new(user2, 'watchlist')

user2_wl.films.delete_if { |film| !user1_wl.films.include? film }
user2_wl.films.each do |film|
  puts "> #{film.title}"
end
