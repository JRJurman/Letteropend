begin
  require "colorize"
rescue LoadError
  puts "we won't judge, but if you want pretty colors, you should totally install colorize"

  class String
    # I can't method missing... halp
    def light_yellow
      self
    end
    def magenta
      self
    end
    def blue
      self
    end
  end

end
require "../lib/letteropend/List.rb"

callbacks = {
  :new_page => lambda{ |list| puts "Getting page ".light_yellow + list.pages.length.to_s.magenta + " from ".light_yellow + "#{list.username}'s #{list.list}".magenta }
}
print "First username: "
user1 = gets.chomp

print "Second username: "
user2 = gets.chomp

user1_wl = List.new(user1, "watchlist", callbacks)
user2_wl = List.new(user2, "watchlist", callbacks)

user2_wl.films.delete_if { |film| !user1_wl.films.include? film }
user2_wl.films.each do |film|
  puts film.title.blue
end
