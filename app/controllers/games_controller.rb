require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    grid_size = rand(8..14)
    generate_grid(grid_size)
  end

  def score
    start_time =Time.parse(params[:time_start])
    end_time = Time.now
    @results = run_game(params[:attempt], params[:grid].split, start_time, end_time)
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    @ran_grid = []
    grid_size.to_i.times do
      @ran_grid << ("A".."Z").to_a.sample
    end
    @ran_grid
  end

  def word_check(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end

  def score_time(attempt, end_time, start_time)
    50 + (attempt.length * 5) - ((end_time - start_time) * 10).to_i
  end

  def run_game(attempt, grid, start_time, end_time)
    @result = { score: 0, message: "not in the grid", time: (end_time - start_time) }
    if attempt.upcase.chars.all? { |l| attempt.upcase.chars.count(l) <= grid.count(l) }
      if word_check(attempt)
        @result[:score] = score_time(attempt, end_time, start_time)
        @result[:message] = "well done"
      else
        @result[:message] = "not an english word"
      end
    end
    return @result
  end
end
