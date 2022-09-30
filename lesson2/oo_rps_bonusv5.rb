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

# Computer personalities

# We have a list of robot names for our Computer class,
# but other than the name, there's really nothing different about each of them.
# It'd be interesting to explore how to build
# different personalities for each robot.
# For example, R2D2 can always choose "rock".
# Or, "Hal" can have a very high tendency to choose "scissors",
# and rarely "rock", but never "paper".
# You can come up with the rules or personalities for each robot.
# How would you approach a feature like this?

require "pry-byebug"
require "yaml"
MSG = YAML.load_file("oo_rps.yml")

module Viewable
  PROMPT_DELAY = 0.7

  def join_conj(arr, conj="or")
    result = Array.new
    item_count = arr.size

    arr.each_with_index do |item, idx|
      result << item + ',' unless idx >= item_count - 2
      result << (item + ' ' + conj) if idx == item_count - 2
      result << item if idx == item_count - 1
    end

    result.join(' ')
  end

  def display_welcome_messages
    wipe_screen
    prompt(MSG["welcome"], 1)
    prompt(MSG["intro"], 1)
  end

  def display_rules
    wipe_screen
    Move::WINNING_COMBOS.each do |move, losers|
      prompt("#{move} beats #{join_conj(losers, 'and')}", 1)
    end
  end

  def introduce_opponent
    wipe_screen
    prompt "Your opponent is #{computer.name}"
  end

  def display_moves
    prompt "#{human.name} threw #{human.move.value}"
    prompt "#{computer.name} threw #{computer.move.value}"
  end

  def display_scores
    prompt(MSG["cur_scores"], 1) unless final_scores?(scores)

    scores.each do |player, score|
      prompt "#{player.name} : #{score}" unless player == 'tie'
    end
    prompt("Tie : #{scores['tie']}", 2)
    wipe_screen
  end

  def final_scores?(scores)
    scores.any? { |player, score| score == 3 && player != 'tie' }
  end

  def display_match_result
    prompt "The match winner is #{winner.name}! The loser was #{loser.name}."
    prompt MSG["final_scores"]
  end

  def display_winner
    if winner == 'tie'
      prompt "Its a tie"
    else
      prompt "#{winner.name} won!"
    end
  end

  def display_history
    #binding.pry
    history.match_results.keys.each do |match|
      prompt "Match ##{match} was won by #{history.match_results[match]}."
      history.moves[match].each do |player, move_list|
        prompt("#{player} made the following moves: #{move_list}", 1)
      end
    end
  end

  def goodbye
    prompt MSG["goodbye"]
  end

  def prompt(str='', delay=PROMPT_DELAY)
    puts ">> " + str
    sleep(delay)
  end
end

module Formattable
  def format_name(name)
    name.gsub(/[^A-Za-z]/,"").strip
  end

  def format_move(choice)
    matches = Move::LEGAL_PLAYS.select do |move|
      move.start_with?(choice)
    end

    matches.size == 1 ? matches.first : nil
  end
end

module Interactable
  include Formattable
  include Viewable

  def welcome
    display_welcome_messages
  
    display_rules if self.proceed?(MSG["rules_ask"], MSG["proceed_error"])

    prompt MSG["continue"]
    gets.chomp
    wipe_screen
  end

  def proceed?(ask, error)
    choice = nil
    loop do
      prompt ask
      choice = gets.chomp.downcase[0]
      break if ['y', 'n'].include?(choice)
      prompt error
    end

    choice == 'y'
  end

  def name_entry
    wipe_screen
    name = ''

    loop do
      prompt MSG["name_ask"]
      name = format_name(gets.chomp)
      break unless name.empty?
      prompt MSG["name_error"]
    end
    name
  end

  def choose_move
    choice = nil
    prompt "Please choose #{join_conj(Move::LEGAL_PLAYS)}. "

    loop do
      choice = format_move(gets.chomp.downcase)
      break if Move::LEGAL_PLAYS.include?(choice)

      prompt MSG["move_error"]
      prompt "Please select #{join_conj(Move::LEGAL_PLAYS)}"
    end

    self.move = Move.new(choice)
  end

  def wipe_screen
    system "clear"
  end
end

class Game
  include Interactable

  attr_accessor :human, :computer, :history, :scores, :winner, :loser, :match_counter

  @@match_counter = 0

  def initialize
    welcome
    @human = Human.new(self)
    change_opponent
    while proceed?("Would you like a different opponent?", MSG["proceed_error"])
      change_opponent
    end
    @history = History.new
  end

  def self.match_num
    @@match_counter
  end

  def play_match
    initialize_match

    loop do
      play_round
      break if [human, computer].any? { |player| scores[player] == 3 }
    end

    match_result

    history.update_results(winner, loser)
    display_history if proceed?(MSG["review_history"], MSG["proceed_error"])
  end

  def initialize_match

## Remaining to-dos:
    # We still aren't adding each new computer player into the scores hash, when the shapeshifter is involved
    # 
    # 

    @scores = { human => 0, computer => 0, 'tie' => 0 }
    #@scores = Hash.new(0)
    #initialize_scores
    scores.default = 0

    @@match_counter += 1
  end

  def match_result
    display_match_result
    display_scores
  end

  def play_round
    human.choose_move
    computer.opponent_move = human.move
    computer.choose_move

    [human, computer].each do |player|
      history.update_move(player) unless dont_update?(winner)
    end

    round_results
  end

  def round_results
    display_moves
    self.winner = determine_winner
    self.loser = [human, computer].select { |player| player != self.winner }.first
    update_scores unless dont_update?(winner)
    display_winner
    display_scores
  end

  def determine_winner
    if human.move > computer.move
      human
    elsif computer.move > human.move
      computer
    else
      'tie'
    end
  end

  def update_scores(player=winner)
    # Problem here - for some reason, the @history attribute is getting added to the scores hash. that is incorrect!
    binding.pry
    @scores[player] += 1
  end

  def dont_update?(player)
    player.class == Computer && Personality::SELF_UPDATING.include?(player.personality)
  end

  def play_again?
    proceed?(MSG["play_again"], MSG["proceed_error"])
  end

  def change_opponent
    self.computer = Computer.new(self)

    introduce_opponent
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

module Personality
  SELF_UPDATING = [:shapeshifter]

  def rock_on
    [['rock'] * 2, Move::LEGAL_PLAYS.sample].flatten.sample
  end

  def benevolent
    [[Move::WINNING_COMBOS[opponent_move.value]] * 2,
     Move::LEGAL_PLAYS.sample].flatten.sample
  end

  def ambivalent
    [Move::WINNING_COMBOS[opponent_move.value], winning_moves].flatten.sample
  end

  def shapeshifter
    binding.pry
    change_name
    name_reflex

    choose_move
    game.history.update_move(self)
    game.update_scores(self) if game.determine_winner == self

    self.name = 'Cylon, the Changeling'
    choose_personality
  end

  def winning_moves
    # find all keys from WINNING_COMBOS whose value contains the opponents move
    Move::WINNING_COMBOS.select do |_, losing_moves|
      losing_moves.include?(opponent_move.value)
    end.keys
  end
end

class Player
  include Interactable
  include Personality

  attr_accessor :move, :name, :game

  def initialize(game)
    @game = game
    @@already_played = Array.new if self.class == Computer
    enter_name
    name_reflex if self.class == Computer
  end
end

class Human < Player
  def enter_name
    self.name = name_entry
  end
end

class Computer < Player
  include Personality

  attr_accessor :opponent_move, :personality, :personality_name, :already_played

  AI_LIST = { 'R2D2, the Rocker' => :rock_on,
              'Bender, the Undecided' => :ambivalent,
              'Sonny, the Protector of Humans' => :benevolent,
              'Cylon, the Shapeshifter' => :shapeshifter }

  def enter_name
    self.name = AI_LIST.keys.delete_if do |new_name|
      @@already_played.include?(new_name)
    end.sample
  end

  def change_name
    self.name = AI_LIST.keys.delete_if do |new_name|
      @@already_played.include?(new_name)
    end.sample
  end

  def name_reflex
    update_already_played
    choose_personality
  end

  def update_already_played
    @@already_played << name
    @@already_played.clear if @@already_played.size == 5
  end

  def choose_personality
    @personality = AI_LIST[name]
  end

  def choose_move
    if personality == :shapeshifter
      send(personality)
    else
      self.move = Move.new(self.send(personality))
    end
  end

  def self.played_this_session
    @@already_played
  end
end

class History
  include Interactable

  attr_accessor :moves, :match_results

  def initialize
    @match_results = Hash.new
    @moves = Hash.new(Hash.new)
  end

  def update_move(player)
    match_num = Game.match_num

    if first_move?(match_num)
      moves[match_num] = { player.name => [player.move.value] }
    elsif first_for_player?(match_num, player)
      moves[match_num][player.name] = [player.move.value]
    else
      moves[match_num][player.name] << player.move.value
    end
  end

  def first_move?(game_num)
    moves[game_num].empty?
  end

  def first_for_player?(game_num, player)
    !moves[game_num][player.name]
  end

  def update_results(winner, loser)
    self.match_results[Game.match_num] = "#{winner.name} beat #{loser.name}"
  end
end

game = Game.new

loop do
  game.play_match
  break unless game.play_again?
  if game.proceed?(MSG["change_machine?"], MSG["proceed_error"])
    game.change_opponent
  end
end

game.goodbye



## Questions for PR Request ##
# 1) Is there an easy way to access the object that an attribute belongs to?
# 2)