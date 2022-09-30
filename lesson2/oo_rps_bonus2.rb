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
  attr_accessor :move, :name, :score

  ROBOT_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny']

  def initialize
    set_name
    @score = 0
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
    @ties = 0
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

  def update_scores(result)
    result == 'tie' ? @ties += 1 : result.score += 1
  end

  def display_winner(winner)
    if winner == 'tie'
      puts "Its a tie"
    else
      puts "#{winner.name} won!"
    end
    
  end

  def display_scores
    [human, computer].each do |player|
      puts "#{player.name} : #{player.score}"
    end

    puts "Tie : #{@ties}"
  end

  def match_result
    winner = [human, computer].max_by { |player| player.score }
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
      next unless [human, computer].any? { |player| player.score == 3 }
      match_result
      break unless play_again?
    end
    goodbye
  end

  protected

  attr_accessor :result
end

Game.new.play
