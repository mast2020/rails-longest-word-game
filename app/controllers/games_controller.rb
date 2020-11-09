require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    @letters_in_grid = []
    10.times do
      @letters_in_grid << alphabet[Random.new.rand(alphabet.length)]
    end
  end

  def score
    @attempt = params[:attempt]
    @letters_in_grid_2 = params[:letters_in_grid].split(" ")
    if attempt_in_grid?(@attempt, @letters_in_grid_2)
      if attempt_an_english_word?(@attempt)
        @result = "Congratulations! #{@attempt} is a valid English word!" # in grid and english
        return @result
      end
      @result = "Sorry but #{@attempt} does not seem to be a valid English word ..."
      return @result
    end
    @result = "Sorry but #{@attempt} can't be built out of #{@letters_in_grid_2}"
    return @result
  end

  private

  def attempt_in_grid?(attempt, grid)
    letters_in_attempt = attempt.upcase.split("")
    letters_in_grid_copy = grid.map { |e| e }
    letters_in_attempt.all? do |letter|
      if letters_in_grid_copy.include?(letter)
        letters_in_grid_copy.delete_at(letters_in_grid_copy.index(letter))
        true
      else
        false
      end
    end
  end

  def attempt_an_english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.downcase}"
    dic_entry_string = open(url).read
    dic_entry_hash = JSON.parse(dic_entry_string)
    dic_entry_hash["found"]
  end
end
