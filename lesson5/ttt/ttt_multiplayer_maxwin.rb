require "yaml"
MSG = YAML.load_file("ttt_multiplayer.yml")

module Viewable
  PROMPT_DELAY = 0.2

  def join_conj(arr, conj="or")
    result = Array.new
    item_count = arr.size

    arr.map(&:to_s).each_with_index do |item, idx|
      result << item + ',' unless idx >= item_count - 2
      result << (item + ' ' + conj) if idx == item_count - 2
      result << item if idx == item_count - 1
    end

    result.join(' ')
  end

  def display_welcome_msg
    prompt MSG["welcome"]
  end

  def display_game_board
    horiz = ('-' * 5 + '+') * size
    spacer = (' ' * 5 + '|') * size
    size.times do |i|
      puts spacer.chop
      display_marker_row(i)
      puts spacer.chop
      puts horiz.chop unless i == size - 1
    end
  end

  def clear_screen_and_display_board
    wipe_screen
    board.draw
  end

  def display_markers
    prompt MSG["list_markers"]
    player_list.each do |player|
      prompt "#{player}: #{player.marker}"
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

    prompt "The match winner is #{result}! The losers are: #{join_conj(losers, "and")}"
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
    end
    size
  end

  def ask_player_total(size)
    player_count = nil
    loop do
      prompt MSG["num_players"]
      player_count = gets.chomp.to_i
      break if player_count.between?(2, size - 1)
    end
    player_count
  end
end

class Board
  include Viewable
  include Interactable
  include Formattable

  attr_reader :squares, :size, :winning_lines

  MIN_SIZE = 3
  MAX_SIZE = 6

  def initialize(size: size=3, player_count: count=2)
    @size = size
    @squares = Hash.new
    reset
    compile_winning_lines(player_count)
  end

  def []=(key, marker)
    squares[key].marker = marker
  end

  def available_squares
    @squares.select { |_, sq| sq.no_marker? }.keys
  end

  def full?
    available_squares.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    @winning_lines.each do |line|
      # make a hash with the counts of markers on the board
      # for the current winning line
      marker_counts = markers_only(line).tally
      if marker_counts.size == 1 && marker_counts.values[0] == size
        return marker_counts.keys[0]
      end
    end
    nil
  end

  def markers_only(line)
    line.map { |key| squares[key].marker.strip }.reject(&:empty?)
  end

  def compile_winning_lines(player_count)
    @winning_lines = Array.new
    square_matrix = squares.keys.each_slice(size).to_a
    binding.pry
    #do_rows_and_cols(square_matrix)
    #do_diagonals(square_matrix)
    compile_winning_lines(square_matrix)
    binding.pry
  end

  def do_rows_and_cols(square_matrix)
    square_matrix.each { |row| winning_lines << row }
    square_matrix.transpose.each { |row| winning_lines << row }
  end

  def do_diagonals(square_matrix)
    winning_lines << (0..size - 1).collect { |idx| square_matrix[idx][idx] }
    winning_lines << (0..size - 1).collect do |idx|
      square_matrix[idx][size - 1 - idx]
    end
  end

  #def compile_winning_lines_alt(square_matrix, player_count)
  #  do_rows_and_cols_alt(square_matrix, player_count)
  #  binding.pry
  #  do_diagonals_alt(square_matrix,player_count)
  #end
  #
  #def do_rows_and_cols_alt(square_matrix, player_count)
  #  square_matrix.each do |row|
  #    row_col_subsets(row, size, player_count)
  #  end
  #
  #  square_matrix.transpose.each do |col|
  #    row_col_subsets(col, size, player_count)
  #  end
  #end
  #
  #def row_col_subsets(line, size, player_count)
  #  # Iterate over the values in the row, with the index value available
  #  # On each iteration, initialize a local variable length to the value of player_count
  #  #   Iterate from length to size (non inclusive)
  #  #   Add slices of the values from row, of value length, to winning_lines
  #  min_win_length = size - (player_count - 2)
  #  (0...line.size).each do |square_index|
  #    length = min_win_length
  #    (length..line.size).each do |slice_size|
  #      next if square_index + slice_size <= line.size
  #      winning_lines << line.slice(square_index, slice_size)
  #    end
  #  end
  #end

# new idea - 
#   > rather than building up all the winning lines and storing them off, then cycling through them one by one
#     could we instead look at an array of marked squares for each player, and check them logically for 
#     being a winner or potential future winner?
#     The rows, columns, and diagonals all seem to have consistent spacing. I.e. where n = board dimension
#       rows and columns: add n to the current square number to get the next square
#       left-> right diagonals: add n + 1 to the current square number to get the next square
#       right-> left diagonals: add n - 1 to the current square number to get the next square

  #def do_diagonals_alt(square_matrix, player_count)
  #  ewAdd = size + 1
  #  weAdd = size - 1
  #  
  #  tot_squares = squares.keys.size
  #  min_diag_length = size - (player_count - 2)
#
  #  ewDiags, weDiags = [[],[]]
  #  diagonals = Array.new
#
  #  1.upto(tot_squares) do |num|
  #    temp = num
  #    while temp <= tot_squares
  #      ewDiags << temp
  #      winning_lines << ewDiags.dup if ewDiags.size >= min_diag_length
  #      temp = temp + ewAdd
  #    end
  #    ewDiags.clear
  #  end
  #end

  def draw
    display_game_board
  end

  def reset
    1.upto(size**2) { |key| @squares[key] = Square.new }
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
  MACHINE_NAMES = ['Revolio Clockberg, Jr.', 'Maria', 'Tik-Tok', 'Daneel Olivaw', 'Marvin']

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
    threats = get_threat_lines(board)

    if defend_or_attack?(threats)
      # offense/defense
      threat_response(threats)
    else
      # random
      get_center_or_random(board)
    end
  end

  def get_threat_lines(board)
    threats = { defense: [], offense: [] }

    board.winning_lines.each do |line|
      line_markers = board.squares.values_at(*line).map(&:marker)
      next unless line_markers.count(Square::INITIAL_MARKER) == 1
      empty_square = get_empty_square(board, line)
      update_threats(board, threats, line_markers, empty_square)
    end

    threats
  end

  def get_empty_square(board, line)
    line.select do |square|
      board.available_squares.include?(square)
    end.first
  end

  def update_threats(board, threats, markers, empty_square)
    if markers.count(marker) == board.size - 1
      threats[:offense] << empty_square
    elsif markers.count(marker) == 0
      threats[:defense] << empty_square
    end
  end

  def defend_or_attack?(threats)
    threats.values.any? { |threat_list| !threat_list.empty? }
  end

  def threat_response(threats)
    # we've already made a list of threatening lines:
    # those we can defend against, and those we can attack.
    # Now we take one at random of the offensive positions, if any
    # otherwise, we take at random from the defensive positions
    [threats[:offense].sample, threats[:defense].sample].compact.first
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
    board.size.even? ? nil : (board.size**2 + 1) / 2
  end
end

class TTTGame
  include Viewable
  include Formattable
  include Interactable

  attr_accessor :player1, :player2, :result, :player_list
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
    @board = Board.new(size: board_size, player_count: num_players)
  end

  def calculate_num_players(board_size)
    board_size > 3 ? ask_player_total(board_size) : 2
  end

  def main_game
    loop do
      board_display
      choose_first_turn
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
      change_turn
      clear_screen_and_display_board if turn.class == Human
    end
  end

  def board_display
    display_markers
    board.draw
  end

  def initialize_players(num_players)
    # got stuck on figuring out how to maintain the marker list
    # may want to think about moving it to the Player class - ?
    # ** Probably not -- 
    # The marker list isn't specific to any given instance of Player. It is specific to the Game class
    self.player_list << Human.new(player_list)
    2.upto(num_players) do |player_num|
      self.player_list << choose_player(player_list)
    end
  end

  def initialize_scores
    @scores = { 'tie' => 0 }
    player_list.each do |player|
      scores[player] = 0
    end
  end

  def choose_first_turn
    binding.pry
    10.times { player_list.shuffle! }
    @turn = player_list.sample
    @turn_num = 1
    prompt "#{turn.name} goes first!"
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
    prompt "It is now #{turn.name}'s turn!"
  end

  def player_moves
    square = turn.choose_square(board)
    board[square] = turn.marker
  end

  def game_over?
    board.someone_won? || board.full?
  end

  def round_results
    update_result
    display_result
    sleep(1)
  end

  def update_result
    self.result = determine_result
  end

  def determine_result
    if board.someone_won?
      player_list.select do |player|
        player.marker == board.winning_marker
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
