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

## Bonus Features #1 and #2

# 1.
# Keeping score
# 
# Right now, the game doesn't have very much dramatic flair. 
# It'll be more interesting if we were playing up to, say, 10 points. 
# Whoever reaches 10 points first wins. Can you build this functionality? 
# We have a new noun -- a score. Is that a new class, or a state of an existing class? 
# You can explore both options and see which one works better.

# 2.
# Add Lizard and Spock
# 
# This is a variation on the normal Rock Paper Scissors game by adding two more options - Lizard and Spock.

def joinor(arr)
  list = ''
  (0..arr.length-2).each do |idx|
    list << arr[idx]
    list << ', '
  end
  list << "or #{arr[arr.length-1]}"
end

class Move
  include Comparable
  attr_reader :value

  WINNING_COMBOS = { "rock" => ['scissors', 'lizard'],
                     "paper" => ['rock', 'spock'],
                     "scissors" => ['paper', 'lizard'],
                     "lizard" => ['spock', 'paper'],
                     "spock" => ['rock', 'scissors'] }

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
    puts "Please choose #{joinor(Move::LEGAL_PLAYS)}"
    loop do
      choice = gets.chomp
      break if Move::LEGAL_PLAYS.include?(choice.downcase)
      puts "That is not a valid choice. Pick #{joinor(Move::LEGAL_PLAYS)}"
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
    @scores = { human => 0, computer => 0, 'tie' => 0 }
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

  def game_result
    display_moves
    result = winner
    update_scores(result)
    display_winner(result)
    puts "The scores after that game are: "
    display_scores
  end

  def winner
    if human.move > computer.move
      human
    elsif computer.move > human.move
      computer
    else
      'tie'
    end
  end

  def update_scores(winner)
    @scores[winner] += 1
  end

  def display_winner(winner)
    if winner == 'tie'
      puts "Its a tie"
    else
      puts "#{winner.name} won!"
    end
  end

  def display_scores
    @scores.each do |player, score|
      puts "#{player.name} : #{score}" unless player == 'tie'
    end

    puts "Tie : #{@scores['tie']}"
  end

  def match_result
    winner = [human, computer].max_by { |player| @scores[player] }
    puts "The match winner is #{winner.name}!"
    puts "Final scores are as follows:"
    display_scores
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again?"
      answer = gets.chomp[0]
      break if !answer.nil? && ['y', 'n'].include?(answer.downcase)
      puts "Invalid choice - please enter y or n"
    end
    answer.downcase == 'y'
  end

  def play
    welcome

    loop do
      human.choose_move
      computer.choose_move
      game_result
      break if [human, computer].any? { |player| @scores[player] == 3 }
    end

    match_result
  end

  protected

  attr_accessor :result
end

loop do
  game = Game.new
  game.play
  break unless game.play_again?
  game.goodbye
end

