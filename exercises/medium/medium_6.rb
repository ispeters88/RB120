# Number Guesser Part 1
# Create an object-oriented number guessing class for numbers in the range 1 to 100,
# with a limit of 7 guesses per game. The game should play like this:

class GuessingGame
  def initialize
    @guesses = nil
    @solution = nil
    @guess = nil
  end

  def play
    @guesses = 7
    @solution = rand(100)

    loop do
      show_remaining_guesses
      @guess = prompt_for_num
      @guesses -= 1
      break if @guess == @solution || @guesses == 0
      display_wrongness_type
    end
    
    display_result
  end

  def show_remaining_guesses
    puts "You have #{@guesses} guesses remaining."
  end

  def prompt_for_num
    guess = nil
    loop do
      puts "Enter a number between 1 and 100:"
      guess = gets.chomp.to_i
      break if (1..100).include?(guess)
      # note - LS suggests using `#cover` here instead - because it is much faster on ranges than `#include`
      puts "Invalid guess. Enter a number between 1 and 100"
    end

    guess
  end

  def display_wrongness_type
    type = @guess > @solution ? 'high' : 'low'
    puts "Your guess is too #{type}"
  end

  def display_result
    if @guess == @solution
      puts "That's the number!\n\nYou won!"
    else
      puts "You have no more guesses. You lost!"
    end
  end
end


game = GuessingGame.new
game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 104
# Invalid guess. Enter a number between 1 and 100: 50
# Your guess is too low.
# 
# You have 6 guesses remaining.
# Enter a number between 1 and 100: 75
# Your guess is too low.
# 
# You have 5 guesses remaining.
# Enter a number between 1 and 100: 85
# Your guess is too high.
# 
# You have 4 guesses remaining.
# Enter a number between 1 and 100: 0
# Invalid guess. Enter a number between 1 and 100: 80
# 
# You have 3 guesses remaining.
# Enter a number between 1 and 100: 81
# That's the number!
# 
# You won!

game.play

# You have 7 guesses remaining.
# Enter a number between 1 and 100: 50
# Your guess is too high.
# 
# You have 6 guesses remaining.
# Enter a number between 1 and 100: 25
# Your guess is too low.
# 
# You have 5 guesses remaining.
# Enter a number between 1 and 100: 37
# Your guess is too high.
# 
# You have 4 guesses remaining.
# Enter a number between 1 and 100: 31
# Your guess is too low.
# 
# You have 3 guesses remaining.
# Enter a number between 1 and 100: 34
# Your guess is too high.
# 
# You have 2 guesses remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.
# 
# You have 1 guess remaining.
# Enter a number between 1 and 100: 32
# Your guess is too low.
# 
# You have no more guesses. You lost!
