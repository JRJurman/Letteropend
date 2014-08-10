require 'net/http'
require 'colorize'
require "letteropend/cli"
require "letteropend/version"

module Letteropend
  extend self

  def get_film_urls(username, list="films")
    #==== CONSOLE STATEMENTS ====#
    def start_statement(u, l) 
      puts "Grabbing ".light_yellow + l.yellow.bold + " URLs for ".light_yellow + u.yellow.bold
    end
    def another_page_statement(p)
      puts "Found another page".light_yellow + " (page #{p})".magenta.bold
    end
    def end_page_statement
      puts "No more pages".magenta
    end
    def error_statement(e)
      puts "something probably went wrong getting the film urls".red
    end
    #== END CONSOLE STATEMENTS ==#

    #========= PROGRAM ==========#
    start_statement(username, list)
    urls = []
    page_number = "1"
    begin
      page = Net::HTTP.get("letterboxd.com", "/#{username}/#{list}/page/#{page_number}/")
      catches = page.scan(/href="(\/film\/\S*)"/).flatten
      if (catches.size == 0)
        error_statement(nil)
      else
        urls.push(*catches)
      end

      # check for another page (stupid pagination)
      nex = page.scan(/a class="paginate-next" href="(\S*)"/).flatten
      if (nex.size == 1)
        page_number = nex[0].match(/(\d+)/).to_s
        another_page_statement(page_number)
      else
        end_page_statement
      end
    end while (nex.size == 1)
    #======= END PROGRAM ========#
    return urls
  end

  def get_total_minutes(uris)
    #==== CONSOLE STATEMENTS ====#
    def start_statement(p, i, t) 
      puts "Scanning ".light_yellow + p.yellow.underline + " (#{i}/#{t} films)".magenta
    end
    def error_statement(e)
      puts "something went wrong getting the film length".red
    end
    def current_statement(a, r)
      puts "Adding ".cyan + a.blue.bold + " minutes; Total Minutes: ".cyan + r.blue.bold
      if r.to_i < 1440
        print "That's ".cyan + (r.to_i/60).to_s.blue.bold + " hours and ".cyan + (r.to_i%60).to_s.blue.bold + " minutes".cyan
      elsif r.to_i < 525600
        print "That's ".cyan + (r.to_i/1440).to_s.blue.bold + " days, ".cyan + (r.to_i%1440/60).to_s.blue.bold + " hours, and ".cyan + (r.to_i%1440%60).to_s.blue.bold + " minutes".cyan
      else
        print "That's ".cyan + (r.to_i/525600).to_s.blue.bold + " years, ".cyan + (r.to_i%525600/1440).to_s.blue.bold + " days, ".cyan + (r.to_i%545600%1440/60).to_s.blue.bold + " hours, and ".cyan + (r.to_i%535600%1440%60).to_s.blue.bold + " minutes".cyan
      end

      puts " -- around ".cyan + (r.to_i/90).to_s.blue.bold + " movies".cyan
    end
    #== END CONSOLE STATEMENTS ==#
    
    #========= PROGRAM ==========#
    result = 0
    uris.each_with_index do |path, index|
      start_statement(path, index, uris.size)
      page = Net::HTTP.get("letterboxd.com", path)
      cat = page.match(/\D*(\d+) mins\D*/)
      if (cat != nil)
        catches = cat.captures
      else
        catches = []
      end
      if (catches.size != 1)
        error_statement(nil)
      else
        result += catches[0].to_i
      end
      current_statement(catches[0].to_s, (result).to_s)
    end
    #======= END PROGRAM ========#
  end
end
