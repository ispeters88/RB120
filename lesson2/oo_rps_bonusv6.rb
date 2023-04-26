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

  def display_opponent_options
    wipe_screen
    Computer::AI_LIST.keys.each_with_index do |machine, num|
      prompt "#{num + 1}: #{machine}"
    end
    prompt "5: Choose for me! (opponent selected at random)"
  end

  def introduce_opponent
    wipe_screen
    prompt "Your opponent is #{name}"
  end

  def display_moves
    prompt "#{human.name} threw #{human.move.value}"
    prompt "#{computer.name} threw #{computer.move.value}"
  end

  def display_scores
    wipe_screen
    prompt(MSG["cur_scores"], 1) unless final_scores?(scores)

    scores.each do |player, score|
      prompt "#{player.name} : #{score}" unless player == 'tie'
    end
    prompt("Tie : #{scores['tie']}", 2)
  end

  def final_scores?(scores)
    scores.any? { |player, score| score == 3 && player != 'tie' }
  end

  def display_match_result
    wipe_screen
    prompt "The match winner is #{winner.name}! The loser is #{loser.name}."
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
    name.gsub(/[^A-Za-z]/, "").strip
  end

  def format_move(choice)
    matches = Move::LEGAL_PLAYS.select do |move|
      move.start_with?(choice)
    end

    matches.size == 1 ? matches.first : nil
  end

  def format_opponent(choice)
    return nil unless choice.between?(1, 5)
    if choice == 5
      Computer::AI_LIST.keys.sample
    else
      Computer::AI_LIST.keys[choice - 1]
    end
  end
end

module Interactable

  def welcome
    display_welcome_messages

    display_rules if proceed?(MSG["rules_ask"], MSG["proceed_error"])

    prompt MSG["continue"]
    gets.chomp
    wipe_screen
  end

  #def continue_keystroke
  #  puts MSG["continue"]
  #  gets.chomp
  #  wipe_screen
  #end

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
    choice
  end

  def choose_opponent
    prompt "Select your opponent: "
    display_opponent_options

    choice = nil
    loop do
      choice = format_opponent(gets.chomp.to_i)
      break if Computer::AI_LIST.keys.include?(choice)

      prompt MSG["opponent_error"]
    end
    choice
  end

  def wipe_screen
    system "clear"
  end
end

class Game
  include Interactable
  include Formattable
  include Viewable

  @@match_counter = 0

  def initialize
    welcome

    @human = Human.new
    @computer = Computer.new
    offer_opponent_options

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
    @scores = { human => 0, computer => 0, 'tie' => 0 }
    scores.default = 0

    @@match_counter += 1
  end

  def match_result
    display_match_result
    display_scores
  end

  def play_round
    human.move = Move.new(human.choose_move)

    computer.turn(human.move)

    [human, computer, computer.morph].compact.each do |player|
      history.update_move(player)
    end

    round_results
  end

  def round_results
    display_moves

    self.winner = determine_winner
    self.loser = determine_loser

    update_scores
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

  def determine_loser
    [human, computer].select { |player| player != winner }.first
  end

  def update_scores
    @scores[winner] += 1
    @scores[loser] += 0
  end

  def play_again?
    proceed?(MSG["play_again"], MSG["proceed_error"])
  end

  def offer_opponent_options
    return unless proceed?(MSG["change_opponent?"], MSG["proceed_error"])
    computer.name = choose_opponent
    computer.assign_personality
    computer.introduce_opponent
  end

  def change_opponent
    offer_opponent_options
  end

  private

  attr_accessor :winner, :loser, :human, :computer, :history, :scores
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
    permanent_name = 'Cylon, the Shapeshifter'
    enter_name([permanent_name])
    assign_personality

    choose_move

    reset_morph
    self.name = permanent_name
    assign_personality
  end

  def reset_morph
    @morph = nil
    @morph = clone
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
  include Formattable
  include Viewable
  include Personality

  attr_accessor :move, :name

  def initialize
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

  attr_reader :morph

  AI_LIST = { 'R2D2, the Rocker' => :rock_on,
              'Bender, the Undecided' => :ambivalent,
              'Sonny, the Protector of Humans' => :benevolent,
              'Cylon, the Shapeshifter' => :shapeshifter }

  def enter_name(unavail=[])
    self.name = AI_LIST.keys.delete_if { |name| unavail.include?(name) }.sample
  end

  def name_reflex
    assign_personality
    introduce_opponent
  end

  def assign_personality
    @personality = AI_LIST[name]
  end

  def choose_move
    if personality == :shapeshifter
      send(personality)
    else
      self.move = Move.new(send(personality))
    end
  end

  def turn(move)
    @opponent_move = move
    choose_move
  end

  private

  attr_accessor :personality, :opponent_move
  attr_writer :morph
end

class History
  include Interactable
  include Formattable
  include Viewable

  attr_reader :match_results, :moves

  def initialize
    @match_results = Hash.new
    @moves = Hash.new(Hash.new)
  end

  def update_move(player)
    if moves[Game.match_num][player.name].nil?
      add_first_move(player)
    else
      append_move(player)
    end
  end

  def add_first_move(player)
    if first_move?
      moves[Game.match_num] = { player.name => [player.move.value] }
    elsif first_for_player?(player)
      moves[Game.match_num][player.name] = [player.move.value]
    end
  end

  def first_move?
    moves[Game.match_num].empty?
  end

  def first_for_player?(player)
    !moves[Game.match_num][player.name]
  end

  def append_move(player)
    moves[Game.match_num][player.name] << player.move.value
  end

  def update_results(winner, loser)
    match_results[Game.match_num] = "#{winner.name}, who defeated #{loser.name}"
  end

  private

  attr_writer :match_results, :moves
end

game = Game.new

loop do
  game.play_match
  break unless game.play_again?
  game.offer_opponent_options
end

game.goodbye
