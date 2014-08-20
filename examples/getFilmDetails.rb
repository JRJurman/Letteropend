# Usage: ruby getFilmDetails.rb
# TODO: Allow the user to pass command line arguments

require_relative '../lib/letteropend'

Letteropend::Film.config do
  on :model_updated do
    puts 'Model was updated'
  end
end

url = 'chopping-mall'
a = Letteropend::Film.new url do
  on :model_updating do
    puts "Runtime: #{runtime}"
  end
end

url = 'ghostbusters'
b = Letteropend::Film.new url, title: 'The Real Ghostbusters', runtime: 107 do
  on :model_updating do
    puts "Runtime: #{runtime}"
  end
end

url = 'duck-soup-1933'
c = Letteropend::Film.new url do
  on :model_updated do
    puts 'We have Duck Soup'
  end
end

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
we_got_movie_sign(c)
