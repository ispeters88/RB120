# Rock/paper/scissors is a game between two players in which each player chooses between three possible moves. Each move
# loses to one move and wins against the other, so the possible result of every game repetition is a win, loss, or a tie
#
# The moves and the rules for each move are as listed below:
#   rock: loses to paper, beats scissors
#   paper: loses to scissors, beats rock
#   scissors: loses to rock, beats paper

# nouns: players, move
# verbs: choose, compare

class Player
  attr_accessor :move, :name
  ROBOT_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny']

  def initialize(type=:human)
    @type = type
    @move = nil
    set_name
  end

  def set_name
    self.name = human? ? prompt_for_name : ROBOT_NAMES.sample
  end

  def prompt_for_name
    name = ''
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.empty?
      puts "You don't have a name? Enter something anyway!"
    end
    name
  end


  def choose_move
    if human?
      choice = nil
      puts "Please choose rock, paper, or scissors"
      loop do
        choice = gets.chomp
        break if ['rock', 'paper', 'scissors'].include?(choice.downcase)
        puts "That is not a valid choice. Rock, paper, or scissors"
      end
      self.move = choice
    else
      self.move = ['rock', 'paper', 'scissors'].sample
    end

  end

  def human?
    @type == :human
  end
end

class Move
  def initialize(rules)
    @rules = rules
  end

end

class Game
  attr_accessor :human, :computer

  WINNING_COMBOS = { rock: ['scissors'],
                     paper: ['rock'],
                     scissors: ['paper'] }

  def initialize
    @human = Player.new(:human)
    @computer = Player.new(:computer)
  end

  def welcome
    puts "Welcome to Rock Paper Scissors - Object Oriented edition!"
  end

  def goodbye
    puts "Thanks for playing. Goodbye!"
  end

  def winner_UI
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
    if WINNING_COMBOS[human.move.to_sym].include?(computer.move)
      puts "#{human.name} won!"
    elsif WINNING_COMBOS[computer.move.to_sym].include?(human.move)
      puts "#{computer.name} won."
    else
      puts "It's a tie"
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
      winner_UI
      break unless play_again?
    end
    goodbye
  end

end

Game.new.play