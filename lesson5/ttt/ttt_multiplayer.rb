require "pry-byebug"

require "yaml"
MSG = YAML.load_file("ttt_multiplayer.yml")

module Viewable
  PROMPT_DELAY = 0.3
  DRAW_SPEED = 0.06

  def join_conj(arr, conj="or")
    output = Array.new
    item_count = arr.size

    arr.map(&:to_s).each_with_index do |item, idx|
      output << item + ',' unless idx >= item_count - 2
      output << (item + ' ' + conj) if idx == item_count - 2
      output << item if idx == item_count - 1
    end

    output.join(' ')
  end

  def display_welcome_msg
    prompt MSG["welcome"]
  end

  def display_game_board
    horiz, spacer = board_display_items

    size.times do |i|
      puts spacer.chop
      sleep(DRAW_SPEED)
      display_marker_row(i)
      sleep(DRAW_SPEED)
      puts spacer.chop
      sleep(DRAW_SPEED)
      puts horiz.chop unless i == size - 1
    end
  end

  def board_display_items
    horiz = ('-' * 5 + '+') * size
    spacer = (' ' * 5 + '|') * size
    [horiz, spacer]
  end

  def clear_screen_and_display_board
    prompt_for_continue
    wipe_screen
    board.draw
  end

  def display_markers
    prompt(MSG["list_markers"], 0.5)
    player_list.each do |player|
      prompt("#{player}: #{player.marker}", 1)
    end
  end

  def display_marker_row(row)
    marker_row = ''

    1.upto(size) do |col|
      marker_row << (' ' * 2)
      marker_row << squares[row * size + col].to_s
      marker_row << (' ' * 2)
      marker_row << '|' unless col == size
    end

    puts marker_row
  end

  def display_result
    board.draw
    if result == 'tie'
      prompt "Its a tie!"
    else
      prompt "#{result} won!"
    end
  end

  def display_scores
    scores.each do |player, score|
      prompt "#{player.name} : #{score}" unless player == 'tie'
    end
    prompt("Tie : #{scores['tie']}", 2)
  end

  def display_goodbye
    prompt MSG["goodbye"]
  end

  def display_match_results
    wipe_screen
    losers = player_list.select { |player| player != result }

    prompt "The match winner is #{result}!"
    prompt "The losers are: #{join_conj(losers, 'and')}"
    prompt MSG["final_scores"]
    display_scores
  end

  def prompt(str='', delay=PROMPT_DELAY)
    puts ">> " + str
    sleep(delay)
  end

  def wipe_screen
    system "clear"
  end
end

module Formattable
  def format_name(name)
    name.gsub(/[^A-Za-z]/, "").strip
  end

  def format_player_type(choice)
    options = { 1 => 'human', 2 => 'computer' }
    options[choice]
  end

  def format_marker(marker)
    marker.strip.capitalize[0]
  end
end

module Interactable
  def valid_choice?(valids, choice)
    valids.include?(choice)
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

  def play_again?
    proceed?(MSG["play_again"], MSG["proceed_error"])
  end

  def choose_player(player_list)
    player_type = choose_player_type
    if player_type == 'human'
      Human.new(player_list)
    else
      Computer.new(player_list)
    end
  end

  def choose_player_type
    choice = nil
    prompt MSG["player2"]

    loop do
      choice = gets.chomp.to_i
      break if valid_choice?([1, 2], choice)
      prompt MSG["player_choice_error"]
    end
    format_player_type(choice)
  end

  def ask_player_name
    name = ''
    loop do
      prompt MSG["name_ask"]
      name = format_name(gets.chomp)
      break unless name.empty?
    end
    name
  end

  def ask_player_marker(used_markers)
    marker = ''
    legal_markers = available_markers(used_markers)
    loop do
      prompt MSG["marker_ask"]
      prompt "Choose from: #{join_conj(legal_markers)}"
      marker = format_marker(gets.chomp)
      break if legal_markers.include?(marker)
      prompt MSG["marker_ask_error"]
    end
    marker
  end

  def available_markers(used_markers)
    TTTGame::MARKER_OPTIONS.reject do |marker|
      used_markers.include?(marker)
    end
  end

  def ask_board_size
    size = nil
    loop do
      prompt MSG["board_size"]
      size = gets.chomp.to_i
      break if size.between?(Board::MIN_SIZE, Board::MAX_SIZE)
      prompt MSG["board_size_error"]
    end
    size
  end

  def ask_player_total(size)
    player_count = nil
    loop do
      prompt MSG["num_players"]
      player_count = gets.chomp.to_i
      break if player_count.between?(2, size - 1)
      prompt "We are looking for a number between 2 and #{size - 1}"
    end
    player_count
  end

  def prompt_for_continue
    prompt MSG["continue"]
    gets.chomp
  end
end

module Sequenceable
  def winning_sequence?(array)
    # trying to combine the various guard clauses involved in checking
    # for a winning sequence. The ways we are checking are scattered and
    # not in sync
    return false unless winning_deltas?(array)

    win_type = winning_deltas.key(delta_values(array))
    if win_type == :row
      all_on_same_row?(array)
    else
      different_and_adjacent_rows?(array)
    end
  end

  def winning_deltas?(array)
    # This method checks if a potential winning sequence has the
    # correct deltas between each contiguous square of the sequence when sorted
    # The deltas are defined in an attribute of this class
    deltas = sequence_deltas(array)
    deltas.uniq.size == 1 && winning_deltas.values.include?(deltas.first.abs)
  end

  def sequence_deltas(sequence)
    # Added this in to serve as a bridge between different use cases for
    # checking the "delta" values between adjacent elements in a sorted array
    ###### may want to move some of this functionality to a Module?
    pairs = sequence.each_cons(2).to_a
    pairs.map { |pair| pair.inject(&:-) }
  end

  def delta_values(winner)
    pairs = winner.each_cons(2).to_a
    pairs.map! { |pair| pair.inject(&:-) }
    pairs.uniq.first.abs
  end

  def all_on_same_row?(sequence)
    # Here we check if all the squares in a sequence
    # are contained in the same row
    sequence.map do |square|
      get_row(square)
    end.uniq.size == 1
  end

  def different_and_adjacent_rows?(sequence)
    # This is used for all other winning sequence types
    # (column, diagonals)
    # where there should never be more than one square on the same row
    row_numbers = sequence.map { |square| get_row(square) }
    row_deltas = sequence_deltas(row_numbers)
    row_deltas.uniq.size == 1 && row_deltas.first.abs == 1
  end

  def get_row(square)
    # This helper method will, given a specific square number,
    # return the row it would fall in, if we were to
    # represent the board in a 2d matrix as opposed to a flat array
    matrix = make_square_matrix
    matrix.find_index { |row| row.include?(square) }
  end

  def make_square_matrix
    squares.keys.each_slice(size).to_a
  end
end

class Board
  include Viewable
  include Interactable
  include Formattable
  include Sequenceable

  attr_accessor :marked_squares
  attr_reader :squares, :size, :min_to_win, :winning_deltas, :winning_line

  MIN_SIZE = 3
  MAX_SIZE = 6

  def initialize(size, players)
    @size = size
    @squares = Hash.new
    @min_to_win = size - (players.count - 2)
    @winning_deltas = { row: 1, col: size, lrdiag: size + 1, rldiag: size - 1 }
    initialize_marked_squares(players)
    reset
  end

  def initialize_marked_squares(players)
    @marked_squares = Hash.new
    players.map(&:marker).each do |marker|
      @marked_squares[marker] = Array.new
    end
  end

  def []=(key, marker)
    squares[key].marker = marker
  end

  def [](key)
    squares[key].marker
  end

  def available_squares
    @squares.select { |_, sq| sq.no_marker? }.keys
  end

  def full?
    available_squares.empty?
  end

  def someone_won?
    marked_squares.any? do |_, squares|
      next if squares.size < min_to_win
      square_combos = get_all_subseqs(squares.sort)
      !!winning_marker(square_combos)
    end
  end

  def get_all_subseqs(squares, min = min_to_win)
    squares.combination(min).to_a
  end

  def winning_marker(square_combos)
    # we check for all possible winning sequences,
    # run them through a few guard clauses
    # then update the winning_line attribute
    winning_combo = square_combos.find { |combo| winning_sequence?(combo) }
    return nil if !winning_combo

    @winning_line = squares[winning_combo.first] if !!winning_combo

    !!winning_combo
  end

  def draw
    display_game_board
  end

  def reset
    1.upto(size**2) { |key| @squares[key] = Square.new }
    marked_squares.each_value(&:clear)
    @winning_line = nil
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def no_marker?
    marker == INITIAL_MARKER
  end

  def to_s
    @marker
  end
end

class Player
  include Viewable
  include Interactable
  include Formattable

  attr_reader :marker, :name

  def to_s
    @name.to_s
  end
end

class Human < Player
  def initialize(player_list)
    enter_name
    choose_marker(player_list)
  end

  def enter_name
    @name = ask_player_name
  end

  def choose_marker(player_list)
    @marker = ask_player_marker(player_list.map(&:marker))
  end

  def choose_square(board)
    square = nil
    prompt "#{name}, " + MSG["choose_square"]
    prompt join_conj(board.available_squares).to_s
    loop do
      square = gets.chomp.to_i
      break if board.available_squares.include?(square)
      prompt MSG["square_error"]
    end
    square
  end
end

class Computer < Player
  MACHINE_NAMES = ['Revolio Clockberg, Jr.', 'Maria',
                   'Tik-Tok', 'Daneel Olivaw', 'Marvin']

  def initialize(player_list)
    @marker = compute_marker(player_list)
    @name = choose_name(player_list)
  end

  def compute_marker(player_list)
    used_markers = player_list.map(&:marker)
    available_markers(used_markers).sample
  end

  def choose_name(player_list)
    used_names = player_list.map(&:name)
    MACHINE_NAMES.reject do |name|
      used_names.include?(name)
    end.sample
  end

  def choose_square(board)
    threats = find_threats(board)

    if !threats.empty?
      attack_or_defend(board, threats)
    else
      get_center_or_random(board)
    end
  end

  def find_threats(board)
    # Here we iterate over all the empty squares and ask if -
    #   > that square was added to the lists of marked squares for each player
    #     would any of the resulting possible sequences (or subsequences)
    #     result in a winning line?
    board.available_squares.find_all do |threat|
      board.marked_squares.any? do |_, squares|
        next if squares.size < board.min_to_win - 1
        threat_subseqs = board.get_all_subseqs([squares, threat].flatten.sort)
        threat_subseqs.any? do |subseq|
          board.winning_sequence?(subseq)
        end
      end
    end
  end

  def get_empty_square(board, line)
    line.select do |square|
      board.available_squares.include?(square)
    end.first
  end

  def attack_or_defend(board, threats)
    # This returns a square -
    #   > first preference - win the game for self
    #   > second preference - block a winning sequence for another player
    attack = find_attack_square(board, threats)

    [attack, threats.sample].compact.first
  end

  def find_attack_square(board, threats)
    existing_line = board.marked_squares[marker]
    return nil if existing_line.size < board.min_to_win - 1
    maybe_winners = board.get_all_subseqs([existing_line, threats].flatten.sort)

    winning_sequence = maybe_winners.find do |sequence|
      board.winning_sequence?(sequence)
    end

    winning_sequence = winning_sequence.nil? ? [] : winning_sequence

    winning_sequence.select do |square|
      board.available_squares.include?(square)
    end.first
  end

  def get_center_or_random(board)
    center = get_centrish_square(board)

    if !!center && board.available_squares.include?(center)
      center
    else
      board.available_squares.sample
    end
  end

  def get_centrish_square(board)
    # for a board of size n, we find
    #   > the true center square, if n is odd
    #   > else, we gather up the four "centrish" squares for an even n
    #     and take a free square at random, if possible
    if board.size.even?
      centers = get_four_center_squares(board)
      centers.select do |center|
        board.available_squares.include?(center)
      end.sample
    else
      (board.size**2 + 1) / 2
    end
  end

  def get_four_center_squares(board)
    # First we model the board squares as a square matrix (2d nested array)

    matrix = board.make_square_matrix
    # These two numbers represent the rows
    # and columns of the 4 "centrish" squares
    center1 = board.size / 2
    center2 = center1 + 1

    # This is a shortcut to generate four "coordinate" arrays - the return
    # value is a 2d nested array containing 2-item subarrays
    coordinates = ([center1, center2] * 2).flatten.permutation(2).to_a.uniq

    coordinates.map do |row, col|
      # note: we have to subtract one here to account for the difference
      # between human counting and machine counting
      matrix[row - 1][col - 1]
    end
  end
end

class TTTGame
  include Viewable
  include Formattable
  include Interactable

  attr_accessor :result, :player_list
  attr_reader :board, :turn, :turn_num, :scores

  ROUND_TOTAL = 3
  MARKER_OPTIONS = ['X', 'O', 'V', 'T', '*', '!']

  def play
    wipe_screen
    display_welcome_msg
    initialize_game_components

    loop do
      initialize_scores
      main_game
      display_match_results
      break unless play_again?
    end
    display_goodbye
  end

  private

  def initialize_game_components
    board_size = ask_board_size
    @player_list = Array.new
    num_players = calculate_num_players(board_size)
    initialize_players(num_players)
    @board = Board.new(board_size, player_list)
  end

  def calculate_num_players(board_size)
    board_size > 3 ? ask_player_total(board_size) : 2
  end

  def main_game
    loop do
      choose_first_turn
      board_display if scores.values.max == 0
      player_move
      round_results
      round_scores
      break if match_over?
      reset
    end
  end

  def player_move
    loop do
      player_moves
      break if game_over?
      clear_screen_and_display_board
      change_turn
    end
  end

  def board_display
    display_markers
    board.draw
  end

  def initialize_players(num_players)
    player_list << Human.new(player_list)
    2.upto(num_players) do
      player_list << choose_player(player_list)
    end
  end

  def initialize_scores
    @scores = { 'tie' => 0 }
    player_list.each do |player|
      scores[player] = 0
    end
  end

  def choose_first_turn
    # We mix the player list up a bunch then pick a player at random
    # We then set the turn data
    10.times { player_list.shuffle! }
    @turn = player_list.sample
    @turn_num = 1
    prompt("#{turn.name} goes first!", 1)
    set_player_order!
  end

  def set_player_order!
    # here we mutatively rotate the player list to reflect the turn order.
    first_turn = player_list.index(turn)
    player_list.rotate!(first_turn)
  end

  def change_turn
    @turn_num = (turn_num == player_list.size - 1 ? 0 : turn_num + 1)
    @turn = player_list[turn_num - 1]
    prompt "It is now #{turn.name}'s turn."
  end

  def player_moves
    # Yield to the Player class (and subclasses) to choose a square to play in
    # Then update the Board data
    square = turn.choose_square(board)
    board[square] = turn.marker
    board.marked_squares[turn.marker] << square
  end

  def game_over?
    board.someone_won? || board.full?
  end

  def round_results
    update_result
    display_result
  end

  def update_result
    self.result = determine_result
  end

  def determine_result
    if board.winning_line
      player_list.select do |player|
        player.marker == board.winning_line.marker
      end.first
    else
      'tie'
    end
  end

  def round_scores
    update_scores
    return if scores.any? do |player, score|
      score == ROUND_TOTAL && player != 'tie'
    end

    prompt_for_continue
    prompt(MSG["cur_scores"], 1)
    display_scores
  end

  def update_scores
    @scores[result] += 1
  end

  def match_over?
    player_list.any? do |player|
      scores[player] == ROUND_TOTAL
    end
  end

  def reset
    board.reset
    wipe_screen
    prompt "Next game!"
  end
end

game = TTTGame.new
game.play
