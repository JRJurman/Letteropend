require_relative "../lib/letteropend"

callbacks = {
  :new_page => lambda{ |list| puts "Getting page {#{list.pages.length}} from #{list.username}'s #{list.list}" }
}
print "First username: "
user1 = gets.chomp

print "Second username: "
user2 = gets.chomp

user1_wl = Letteropend::List.new(user1, "watchlist", callbacks)
user2_wl = Letteropend::List.new(user2, "watchlist", callbacks)

user2_wl.films.delete_if { |film| !user1_wl.films.include? film }
user2_wl.films.each do |film|
  puts "> #{film.title}"
end
