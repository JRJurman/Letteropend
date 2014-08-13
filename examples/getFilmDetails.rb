require_relative "../lib/letteropend"

title = "Chopping Mall"
url = "/film/chopping-mall/"
f = Letteropend::Film.new(title, url)

runtime = f.runtime
puts "#{title}'s runtime is: #{runtime} minutes"

tagline = f.tagline
puts "#{title}'s tagline is: #{tagline}"
