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

# Keep track of a history of moves
# 
# As long as the user doesn't quit, keep track of a history of 
# moves by both the human and computer. 
# What data structure will you reach for? 
# Will you use a new class, or an existing class? 
# What will the display output look like?

require "pry-byebug"
require "yaml"
MSG = YAML.load_file("oo_rps.yml")

module Viewable
  def joinor(arr)
    list = ''
    (0..arr.length-2).each do |idx|
      list << arr[idx]
      list << ', '
    end
    list << "or #{arr[arr.length-1]}"
  end

  def welcome
    puts MSG["welcome"]
  end

  def goodbye
    puts MSG["goodbye"]
  end

  def display_moves
    puts "#{human.name} threw #{human.move.value}"
    puts "#{computer.name} threw #{computer.move.value}"
  end

  def display_winner
    if result == 'tie'
      puts "Its a tie"
    else
      puts "#{result.name} won!"
    end
  end
   
  def display_scores
    scores.each do |player, score|
      puts "#{player.name} : #{score}" unless player == 'tie'
    end
    puts "Tie : #{scores['tie']}"
  end
end

module Interactable
  def proceed?(ask, error)
    choice = nil
    loop do
      puts ask
      choice = gets.chomp.downcase[0]
      break if ['y','n'].include?(choice)
      puts error
    end

    choice == 'y'
  end

  def name_entry
    name = ''

    loop do
      puts MSG["name_ask"]
      name = gets.chomp
      break unless name.empty?
      puts MSG["name_error"]
    end
    name
  end

end

class Game
  include Interactable
  include Viewable

  attr_accessor :human, :computer, :history, :scores, :result, :match_counter

  @@match_counter = 0

  def initialize
    @human = Human.new
    @computer = Computer.new
    @history = History.new
  end

  def self.get_match_num
    @@match_counter
  end

  def play_match
    initialize_match

    loop do
      play_round
      break if [human, computer].any? { |player, score| scores[player] == 3 }
    end

    match_result
    history.update_results(result)
    history.display if proceed?(MSG["review_history"], MSG["proceed_error"])
  end

  def initialize_match
    @scores = { human => 0, computer => 0, 'tie' => 0 }
    @@match_counter += 1
  end

  def match_result
    puts "The match winner is #{result.name}!"
    puts "Final scores are as follows:"
    display_scores
  end

  def play_round
    human.choose_move
    computer.choose_move
    history.update_moves(human, computer)
    round_results
  end

  def round_results
    display_moves
    self.result = winner
    update_scores
    display_winner
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

  def update_scores
    @scores[winner] += 1
  end

  def play_again?
    proceed?(MSG["play_again"], MSG["proceed_error"])
  end
end

class Player
  include Interactable
  include Viewable

  attr_accessor :move, :name

  ROBOT_NAMES = ['R2D2', 'Hal', 'Chappie', 'Sonny']

  def initialize
    set_name
  end
end

class Human < Player
  def set_name
    self.name = name_entry
  end

  def choose_move
    choice = nil
    puts "Please choose #{joinor(Move::LEGAL_PLAYS)}"

    loop do
      choice = gets.chomp.downcase
      break if Move::LEGAL_PLAYS.include?(choice)
      puts "Sorry, that is not a valid choice. Please select #{joinor(Move::LEGAL_PLAYS)}"
    end

    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = "Machine"
  end

  def choose_move
    self.move = Move.new(Move::LEGAL_PLAYS.sample)
  end
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
    value == other_move.value ? 0 : find_winner(other_move)
  end

  protected

  def find_winner(other_move)
    WINNING_COMBOS[value].include?(other_move.value) ? 1 : -1
  end
end

class History
  include Interactable

  attr_accessor :moves, :match_results

  def initialize
    @match_results = Hash.new
    @moves = Hash.new(Hash.new)
  end

  def update_moves(human, computer)
    match_num = Game.get_match_num

    if first_move?(match_num)
      self.moves[match_num] = { human.name => [human.move.value],
                                computer.name => [computer.move.value] }
    else
      self.moves[match_num][human.name] << human.move.value
      self.moves[match_num][computer.name] << computer.move.value
    end
  end

  def first_move?(game_num)
    self.moves[game_num].empty?
  end

  def update_results(result)
    self.match_results[Game.get_match_num] = result.name
  end

  def display
    match_results.keys.each do |match|
      puts "Match ##{match} was won by #{match_results[match]}."
      moves[match].each do |player, move_list|
        puts "#{player} made the following moves: #{move_list}"
      end
    end
  end
end

game = Game.new
game.welcome

loop do
  game.play_match
  break unless game.play_again?
end

game.goodbye

