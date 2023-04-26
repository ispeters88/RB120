# Guess a Number is a 1 player game, in which the player receives a set number of guesses to correctly identify 
# a randomly selected secret number. 
# After each turn, the player is given 1 clue about the number - whether the most recent guess
# was higher or lower than the secret number

# verbs - 
#   > There aren't really any real verbs here. What the player is doing each 'turn' involves "taking" a guess, or
#   simply "guessing". 
# nouns - guess

require "pry-byebug"

class GuessingGame
  NUMBER_OF_PLAYERS = 1
  NUMBER_OF_GUESSES = 7
  ANSWER_RANGE = (1..100)

  def initialize
    @players = generate_player_list
    @secret_number = nil
    @result = nil
  end

  def generate_player_list
    player_list = Array.new

    NUMBER_OF_PLAYERS.times do 
      player_list << Player.new
    end
    
    player_list
  end

  def play
    reset_game
    play_game
    display_result
  end

  def reset_game
    @players.each { |player| player.guesses_remaining = NUMBER_OF_GUESSES }
    @secret_number = rand(ANSWER_RANGE)
  end

  def play_game
    loop do
      player_turns
      break if @players.any? { |player| player.guess == @secret_number }
    end
  end

  def player_turns
    @players.each do |player| 
      player.take_guess
      if player.guess == @secret_number
        @result = player
        return
      elsif player.guesses_remaining == 0
        return
      end
      binding.pry
      display_wrongness_type(player.guess)
    end
  end

  def display_wrongness_type(guess)
    type = guess > @secret_number ? 'high' : 'low'
    puts "That guess is too #{type}"
  end

  def display_result
    if @players.none? { |player| player.guess == @secret_number }
      puts "No one guessed the number. Pathetic!"
    else
      puts "#{@result} won. Congratulations!"
    end
  end
end

class Player
  attr_accessor :guesses_remaining
  attr_reader :guess

  def initialize
    @name = ask_name
    @guess = nil
    @guesses_remaining = nil
  end

  def ask_name
    name = ''
    loop do
      puts "What is your name?"
      name = format_name(gets.chomp)
      break if name.length > 1
    end
    name
  end

  def format_name(name)
    name.gsub(/[^A-Za-z]/,"")
  end

  def take_guess
    @guess = prompt_for_guess
    @guesses_remaining -= 1
  end

  def prompt_for_guess
    guess = nil
    loop do
      puts "Enter a number between 1 and 100:"
      guess = gets.chomp.to_i
      break if (1..100).cover?(guess)
      puts "Invalid guess. Enter a number between 1 and 100"
    end
    guess
  end

  def out_of_guesses?
    @guesses_remaining == 0
  end

  def to_s
    @name
  end
end

# In my opinion, it doesn't seem worth it to create a separate class (or module) for Players. The one benefit might
# be a theoretical multiplayer version of this game ... but TBH that feels a bit pointless. Will proceed anyway for practice

game = GuessingGame.new

game.play