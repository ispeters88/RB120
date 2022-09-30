# Rock/paper/scissors is a game between two players
# in which each player chooses between three possible moves.
# Each move loses to one move and wins against the other,
# so the possible result of every game repetition is a win, loss, or a tie
#
# The moves and the rules for each move are as listed below:
#   rock: loses to paper, beats scissors
#   paper: loses to scissors, beats rock
#   scissors: loses to rock, beats paper

# nouns: players, game, move
# verbs: choose, compare

class Move
  include Comparable
  attr_reader :value

  WINNING_COMBOS = { "rock" => ['scissors'],
                     "paper" => ['rock'],
                     "scissors" => ['paper'] }

  LEGAL_PLAYS = WINNING_COMBOS.keys

  def initialize(value)
    @value = value
  end

  def <=>(other_move)
    value == other_move.value ? 0 : winner?(other_move)
  end

  protected

  def winner?(other_move)
    WINNING_COMBOS[value].include?(other_move.value) ? 1 : - 1
  end
end

class Player
  attr_accessor :move, :name

  ROBOT_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny']

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "You don't have a name?? Enter something anyway!"
    end
    self.name = name
  end

  def choose_move
    choice = nil
    puts "Please choose rock, paper, or scissors"
    loop do
      choice = gets.chomp
      break if Move::LEGAL_PLAYS.include?(choice.downcase)
      puts "That is not a valid choice. Rock, paper, or scissors"
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ROBOT_NAMES.sample
  end

  def choose_move
    self.move = Move.new(Move::LEGAL_PLAYS.sample)
  end
end

class Game
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def welcome
    puts "Welcome to Rock Paper Scissors - Object Oriented edition!"
  end

  def goodbye
    puts "Thanks for playing. Goodbye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move.value}"
    puts "#{computer.name} chose #{computer.move.value}"
  end

  def winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif computer.move > human.move
      puts "#{computer.name} won"
    else
      puts "Its a tie"
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Invalid choice - please enter y or n"
    end
    answer.downcase == 'y'
  end

  def play
    welcome

    loop do
      human.choose_move
      computer.choose_move
      display_moves
      winner
      break unless play_again?
    end
    goodbye
  end
end

Game.new.play

## Compare this design with the one in the previous assignment:
#
# what is the primary improvement of this new design?
# what is the primary drawback of this new design?
#
# The primary improvement is to take dense,
# ugly logic and simplify it. This could be
# particularly in the event of increasing the
# complexity of the game design
#   > for example, adding additional move options,
# or more players, etc

# Primary drawback is additional code and
# class design to keep track of.
#
# > Summary @ end of assignment uses the term
# "indirection" - referring to more complex
# "paths" of class definition we are needing
# to traverse when executing the game logic
# (so to speak)
