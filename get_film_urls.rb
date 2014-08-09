require 'net/http'
require 'colorize'

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
