# Number Guesser Part 2
# In the previous exercise, you wrote a number guessing game that determines a secret number between 1 and 100, 
# and gives the user 7 opportunities to guess the number.
# 
# Update your solution to accept a low and high value when you create a GuessingGame object, 
# and use those values to compute a secret number for the game. 
# You should also change the number of guesses allowed so the user can always win if she uses a good strategy. 
# You can compute the number of guesses with:

# Math.log2(size_of_range).to_i + 1

class GuessingGame

  def initialize(lower, upper)
    @guesses = nil
    @solution = nil
    @guess = nil
    #@lower, @upper = ask_range_values
    @lower, @upper = lower, upper
  end

  def ask_range_values
    puts "Please enter the lower and upper bounds for the guessing range\nUpper bound:"
    lower = get_range_boundary
    puts "Lower bound:"
    upper = get_range_boundary

    [lower, upper]
  end

  def get_range_boundary
    boundary = nil
    loop do
      boundary = gets.chomp
      break if boundardy.to_i.to_s == boundardy
    end

    boundardy.to_i
  end

  def play
    @guesses = Math.log2(@upper - @lower).to_i + 1
    @solution = rand(@lower..@upper)

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
      puts "Enter a number between #{@lower} and #{@upper}:"
      guess = gets.chomp.to_i
      break if (@lower..@upper).include?(guess)
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


# Examples:

game = GuessingGame.new(501, 1500)
game.play

# You have 10 guesses remaining.
# Enter a number between 501 and 1500: 104
# Invalid guess. Enter a number between 501 and 1500: 1000
# Your guess is too low.
# 
# You have 9 guesses remaining.
# Enter a number between 501 and 1500: 1250
# Your guess is too low.
# 
# You have 8 guesses remaining.
# Enter a number between 501 and 1500: 1375
# Your guess is too high.
# 
# You have 7 guesses remaining.
# Enter a number between 501 and 1500: 80
# Invalid guess. Enter a number between 501 and 1500: 1312
# Your guess is too low.
# 
# You have 6 guesses remaining.
# Enter a number between 501 and 1500: 1343
# Your guess is too low.
# 
# You have 5 guesses remaining.
# Enter a number between 501 and 1500: 1359
# Your guess is too high.
# 
# You have 4 guesses remaining.
# Enter a number between 501 and 1500: 1351
# Your guess is too high.
# 
# You have 3 guesses remaining.
# Enter a number between 501 and 1500: 1355
# That's the number!
# 
# You won!

game.play

# You have 10 guesses remaining.
# Enter a number between 501 and 1500: 1000
# Your guess is too high.
# 
# You have 9 guesses remaining.
# Enter a number between 501 and 1500: 750
# Your guess is too low.
# 
# You have 8 guesses remaining.
# Enter a number between 501 and 1500: 875
# Your guess is too high.
# 
# You have 7 guesses remaining.
# Enter a number between 501 and 1500: 812
# Your guess is too low.
# 
# You have 6 guesses remaining.
# Enter a number between 501 and 1500: 843
# Your guess is too high.
# 
# You have 5 guesses remaining.
# Enter a number between 501 and 1500: 820
# Your guess is too low.
# 
# You have 4 guesses remaining.
# Enter a number between 501 and 1500: 830
# Your guess is too low.
# 
# You have 3 guesses remaining.
# Enter a number between 501 and 1500: 835
# Your guess is too low.
# 
# You have 2 guesses remaining.
# Enter a number between 501 and 1500: 836
# Your guess is too low.
# 
# You have 1 guess remaining.
# Enter a number between 501 and 1500: 837
# Your guess is too low.
# 
# You have no more guesses. You lost!

# Note that a game object should start a new game with a new number to guess with each call to #play.

