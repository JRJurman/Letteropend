require_relative "../lib/letteropend"

alert = {
  :pulling_film => proc{ puts "PULLING NOW!" }
}

url = "/film/chopping-mall/"
a = Letteropend::Film.new(url, {}, alert)

url = "/film/ghostbusters/"
b = Letteropend::Film.new(url, {:title=>"The Real Ghostbusters", :runtime=>107}, alert)

def we_got_movie_sign(movie)
  puts "The title is : #{movie.title}"
  
  runtime = movie.runtime
  puts "#{movie.title}'s runtime is: #{movie.runtime} minutes"
  
  tagline = movie.tagline
  puts "#{movie.title}'s tagline is: #{movie.tagline}"
  
  overview = movie.overview
  puts "#{movie.title}'s overview is: #{movie.overview}"
  puts "\n\n"
end

we_got_movie_sign(a)
we_got_movie_sign(b)


