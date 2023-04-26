# Tic Tac Toe
#
# Description of program
# > Tic Tac Toe is a game where players take turns playing distinct markers on a board with square dimensions that is
# divided into boxes where the markers are placed. A player wins by completing an n-consecutive sequence of their
# individual marker on the board, where n is equal to the dimension size of the board used. If the board is filled and
# there is no such sequence for either player, the game results in a tie.

# Nouns: Game, player, marker, turn, board
# Verbs: Place


# Brainstorming


## ideas for enabling "multiplayer"
# offer board size option (probably limit to a specific ceiling)
# then offer number of players, up to n-1 where n = board size
# need to think about gathering not just all the winning lines with length = board size, but also
# shorter versions of each line, dependent on the number of players
#   > more players, less squares to win!


## things to do to make this work
# 1. add prompt for board size (this should be in the main game as well)
#       > in constructor method for Board class?
#   DONE - 10/10/22
# 2. add prompt for player count
#     > rule: player count < board size. So if board size is 3, max is 2 players. board size 4, we can do up to 3 players - etc
#   DONE - 10/10/22. 
# ** Leaving off here for the night. **
#     > This last part probably could be refactored but it is at least functional for now.


# 3. add in an IVar to the TTTGame class for the player list
  # DONE - 10/11/22
# 4. Add in logic to accomodate the player list
#       [a] constructing all the additional players and adding them to the player list - DONE 10/11/22
#       [b] alternating turns between each player in the list - DONE 10/11/22
#       [c] getting names for all the players. And, update the language when asking for names - i.e "What is Player X's name?"
#             > DONE 10/11/22
#       [d] initializing the scores for a match - DONE 10/11/22
#       [e] defining what constitutes a "tie" with multiple players - think it should still be a "full board", which means
#           we don't need any changes for this one, but think on this some more.
#       [f] update any other logic that references [player1, player2] or anything similar, to instead reference the entire
#           player list - DONE 10/11/22
#       [g] add marker options - DONE 10/11/22
#
# > ALL ITEMS DONE AS OF 10/11/22

# 5. add in logic for compiling @winning_lines for Board object. 
#     > rule: consecutive markers in a row should be equal to the number of players. So 3 players on a board size of 4
#             only need 3 markers in a row to win
#
#             To implement this, we will need to take x-sized combinations of the winning lines, where x is the 
#             number of players
#             We can either do this as we are doing the initial compile of the winning lines, or we can do it after
#                 > Do we have a built in method that will do this easily? Or do we have to build it?
#       ** It won't be this simple, due to the diagonals! The rows and columns should work with this approach, but the 
#         diagonals won't. We will need another solution for the diagonals
#       ** Random observations: 
#             1. Diagonals flowing "East>West" can be constructed by adding (n+1) to the square position
#                of the prior square, where n is the dimension size of the board.
#             2. Diagonals flowing "West>East" can be constructed by adding (n-1) to the square position
#                of the prior square, where n is the dimension size of the board
#         *Idea: Iterate over the square position numbers. On each iteration:
#                   > Initialize two arrays, one for E>W diagonal, and one for W>E diagonal
#                   > Check for existence a E>W and a W>E diagonal square, based on the above observation. 
#                     > If one is found, add it to the corresponding array, and continue to check for the next 
#                       possible diagonal, using the same "home" square. 
#                     > If one is not found, check if the current diagonal square array is >= the number of players
#                         > If so, add it (and all its subarrays with size >= number of players) to the winning_lines array
#                         > If not, delete it and move on.

# 6. Improve terminal prompts, particularly in response to incorrect input - some of the responses are just the same
# message, and don't explain what is wrong with the received input - DONE 10/14/22



# Board - constructor method thoughts
    # size/layout of the board
    # occupied squares
    # empty squares
    #   > perhaps occupied and empty squares are maintained in the same collaborator object


    # from TTTGame#initialize_players method
    # got stuck on figuring out how to maintain the marker list
    # may want to think about moving it to the Player class - ?
    # ** Probably not -- 
    # The marker list isn't specific to any given instance of Player. It is specific to the Game class



# Extra unused code

#if line.all? { |key| squares[key].marker == TTTGame::PLAYER1_MARKER }
#  return TTTGame::PLAYER1_MARKER
#elsif line.all? { |key| squares[key].marker == TTTGame::PLAYER2_MARKER }
#  return TTTGame::PLAYER2_MARKER
#end



#player1_moves
#break if game_over?
#
#player2_moves
#break if game_over?
#clear_screen_and_display_board


#def player1_moves
#  square = player1.choose_square(board)
#  board[square] = player1.marker
#end
#
#def player2_moves
#  square = player2.choose_square(board)
#  board[square] = player2.marker
#end



#case board.winning_marker
#when player1.marker
#  prompt "Player 1 won!"
#when player2.marker
#  prompt "Player 2 won!"
#else
#  prompt "Its a tie!"
#end


#get_defensive_threats(board).each { |threat| threats[:defense] << threat }
#get_offensive_threats(board).each { |threat| threats[:offense] << threat }

#def get_potential_threats(board, mark_counts)
#  board.winning_lines.select do |line|
#    next unless mark_counts.size == 1
#    mark_counts.values[0] = board.size - 1
#  end
#end
#
#def get_defensive_threats(board)
#  board.winning_lines.select do |line|
#    mark_counts = board.markers_only(line).tally
#    next if mark_counts.keys.include?(self.marker)
#    next unless mark_counts.size == 1
#    mark_counts.values[0] == board.size - 1
#  end
#end
#
#def get_offensive_threats(board)
#  board.winning_lines.select do |line|
#    mark_counts = board.markers_only(line).tally
#    mark_counts[self.marker] == board.size - 1 && mark_counts.size == 1
#  end
#end


    #threats = get_threat_lines(board)
    #
    #if defend_or_attack?(threats)
    #  # offense/defense
    #  threat_response(threats)
    #else
    #  # random
    #  get_center_or_random(board)
    #end

    #def format_for_threat_check(existing_line, threat)
    #  [board.marked_squares[marker], threat].flatten.sort
    #end    

#  ## shouldn't need this anymore - we are checking for square emptiness within the find_threats method ##
#def defend_or_attack?(threats)
#  threats.values.any? { |threat_list| !threat_list.empty? }    
#end

#def threat_response(threats)
#  # we've already made a list of threatening lines:
#  # those we can defend against, and those we can attack.
#  # Now we take one at random of the offensive positions, if any
#  # otherwise, we take at random from the defensive positions
#  [threats[:offense].sample, threats[:defense].sample].compact.first
#end


#.select do |square|
        #board.available_squares.include?(square)
      #end.first

#marker_counts = board.markers_only(line).tally

    #return nil if potential_winners.empty?
#
#
    #potential_winners.each do |winner|
    #  if winning_deltas.include?(delta_values(winner))
    #    return board[winner.first].marker
    #  end
    #end
    #nil


#######
# thought this was a nice partner method to the boolean winning_deltas? that i kept. But doesn't seem to be necessary for
# this game. Noteworthy in case a future version of this game or a similar one could use it

def delta_values(winner)
  pairs = winner.each_cons(2).to_a
  pairs.map! { |pair| pair.inject(&:-) }
  pairs.uniq.first
end

#######

# Planning for compiling winning_lines for multiplayer game

#       ** Random observations: 
#             1. Diagonals flowing "East>West" can be constructed by adding (n+1) to the square position
#                of the prior square, where n is the dimension size of the board.
#             2. Diagonals flowing "West>East" can be constructed by adding (n-1) to the square position
#                of the prior square, where n is the dimension size of the board
#         *Idea: Iterate over the square position numbers. On each iteration:
#                   > Initialize two arrays, one for E>W diagonal, and one for W>E diagonal
#                   > Check for existence a E>W and a W>E diagonal square, based on the above observation. 
#                     > If one is found, add it to the corresponding array, and continue to check for the next 
#                       possible diagonal, using the same "home" square. 
#                     > If one is not found, check if the current diagonal square array is >= the number of players
#                         > If so, add it (and all its subarrays with size >= number of players) to the winning_lines array
#                         > If not, delete it and move on.

# Realization after first pass at implementing
#   > The West>East observation does not work! We aren't dealing with a straight line, we are dealing with a square
# matrix. So we need to reconsider how to handle this
# Thought - it seems that a W>E diagonal exists ONLY when square_num - 1 is greater than 1


# Additional brainstorming notes I made while working on the new version

# new idea - 
#   > rather than building up all the winning lines and storing them off, then cycling through them one by one
#     could we instead look at an array of marked squares for each player, and check them logically for 
#     being a winner or potential future winner?
#     The rows, columns, and diagonals all seem to have consistent spacing. I.e. where n = board dimension
#       rows and columns: add n to the current square number to get the next square
#       left-> right diagonals: add n + 1 to the current square number to get the next square
#       right-> left diagonals: add n - 1 to the current square number to get the next square


# problem statement
# Given a sorted sequence of integers, nums, a minimum subsequence length min_len, 
# and a limited number of specific gap values between adjacent elements in nums:
# > determine if a subsequence with size >= min_len
# can be found such that all adjacent values are separated by the same gap value
# OR, alternatively,
# > find all subsequences of length min_len or greater, whose values are all separated by the same gap value.

# idea:
# Take all 2-contiguous-element subsets and add them to a 2d nested array
# Find the difference between each 2-element subset
# Check that those differences are all the same

# This is useful, but isn't sufficient to check the entire list of markers for a player. We need to check all
# subsets that are at least the min_to_win size

# notes on a bug I discovered related to #winning_deltas
    # found a significant bug with this
    # 
    # > we are allowing sequences that "wrap" around the board
    # i.e. a row sequence that traverses into the next row - same could be true for a column
    #     (don't think this is possible for a diagonal, but think on it more)
    # so we need to add in guard clauses of some kind to defend against this.
    # Took a screenshot of an example where this showed itself - in this example, 
    # 7 and 10 were judged as threats. 7 is correct! 10 is absolutely not.

# and my notes to resolve it

  # thoughts on guard clause - 
  # we only need to invoke the guard close if the delta value of a winning combo is 1
  # if so, we want to know if there are numbers on mukltiple different "rows" of the square matrix board
  # can think of the rows as representing multiples of the board size. 
  #     > in a given row, all the squares with the exception of the last square, will be the same 
  #       integer multiple of the board size. The last square will be the next highest multiple
  # So we could think about creating a partition of the values from the potentially winning combo. 
  # something like : 
  #   row.partition { |num| num / 5 == row[0] / 5 }
  # The main rule for this partition is that there should only be at most 1 subarray with >1 elements
  # eg. For a winning combo of length 4, such a partition with two subarrays of size two each would
  # indicate that we have "wrapped" around to the next row.
  #   One subarray of 3 elements and 1 of 1 would be fine - as well as one of 4 and one of 0.

# misc other notes

    # realizing that this won't be sufficient - we will allow wrapped lines that start on the last square of a row.
    # for ex. on a board with size 5, we will allow the line 10, 11, 12, 13 to win. 
    # we need a reliable way to confirm which row a specific square is in - and this proposed method needs to be 
    # board size agnostic

    # call it row_for_square or something like that


  # hypothesis - 
  # we only need to check the subsequences for the current turn
  #   > but we don't have intrinsic access to the current turn - we would need to pass this in, since its an attribute
  # of the TTTGame class
  #

  # To start, we will check all the player markers. 
  # Once functional, reconsider if its preferable to pass in the turn from the Game class so that we are only checking one
  # player each turn (thinking this would probably be better...)
  
  
## this was an interesting method
# at one point I was planning on using this to find sequences that wrapped around rows
# the idea was to create two arrays based on the result from dividing each square value into the board size
# since only the last square in a row would "Bump up" to the next board size multiple, we should never have
# a size of 2 or more for both subarrays in the partition.
# This proved to be not so simple... found a much better approach instead

def row_wrap?(winner)
  winner.partition do |square|
    board.size / square == board.size / winner[0]
  end.map(&:size).min == 1
end


#    # here we have a convoluted, long && conditional, so we turn it into
#    # an array and then run all? on the array. Is there an easier way?
#    [pairs.uniq.size == 1,
#     winning_deltas.include?(pairs.uniq.first.abs),
#     !all_on_same_row?(
#  ]

  def update_threats(board, threats, markers, empty_square)
    if markers.count(marker) == board.size - 1
      threats[:offense] << empty_square
    elsif markers.count(marker) == 0
      threats[:defense] << empty_square
    end
  end  

  def attack_or_defend(board, threats)
    # This returns a square -
    #   > first preference - win the game for self
    #   > second preference - block a winning sequence for another player
    # Fixing some other areas revealed a bug in this logic
    # >> We are qualifying a sequence as an "attack threat" even if the existing line has < size - 1 items in it
    # also, should probably do "find all" instead of "find", below?


    # update: ended up fixing it by simplifying this method, moving the finding attacking square functionality to a 
    # separate method, and then adding a "return nil if size < min_to_win - 1" guard clause (see below)
    attack = find_attack_square(board, threats)

    [attack, threats.sample].compact.first
  end  

  def find_attack_square(board, threats)
    existing_line = board.marked_squares[marker]
    return nil if existing_line.size < board.min_to_win - 1
    threats.find do |threat|
      board.winning_deltas?([existing_line, threat].flatten.sort)
    end
  end

  def find_threats(board)
    # This is currently broken. I need to account for row wraps and this is not doing it
    # Perhaps pull some of the logic out of board.winning_marker to more cleanly
    # do the check for a row sequence where there are two different rows represented.

    # > Update: fixed as below:
    board.available_squares.find_all do |threat|
      board.marked_squares.any? do |_, squares|
        next if squares.size < board.min_to_win - 1
        threat_subseqs = board.get_all_subseqs([squares, threat].flatten.sort)
        threat_subseqs.any? do |subseq|
          !board.row_wrap?(subseq) && board.winning_deltas?(subseq)
        end
      end
    end
  end  


## Row Wrap stuff

def row_wrap?(sequence)
  # This is a helper method used in a few places to ensure that a 
  # potential winning sequence is not a "row" tyoe sequence that wraps
  # around 2 separate rows. It is necessary because our "deltas" approach
  # to calculating winning sequences qualifies as a "row" any sorted 
  # sequence of numbers, where the difference between each 
  # adjacent numnber is equal to 1
  delta_values(sequence) == 1 && !all_on_same_row?(sequence)
end

# || row_wrap?(winning_combo)
#winning_combo = nil if row_wrap?(winning_combo)
#!board.row_wrap?(subseq) && board.winning_deltas?(subseq)


#notes on get_centrish_square


    # this is not currently finding a "centrish" square. It either finds the true center if the board size is odd,
    # or returns nil, which results in a random square choice

    # simplest to handle the board as a 2d matrix here
    # and then leverage this piece from the single player version of this game:
    #   square_matrix = squares.keys.each_slice(size).to_a
    # along with some code to find the "center rows" as well as center squares

    # really, we should be getting two numbers, and creating a square matrix out of the possible permutations of those numbers
    # so for ex, on a board sized 4
    # we want row/column combinations of 2 and 3 (counting the human way) or 1 and 2 (counting the machine way)
    # > proceeding with machine counting for simplicity
    # our squares would be found in the square matrix via [2,2], [2,3], [3,2], [3,3]
    # so the question is - how do we pull this out from an n-sized board with consistency (assuming n is even)


# added a module `Sequenceable`, and moved all this stuff out of the Board class and into it
#  def winning_sequence?(array)
#    # trying to combine the various guard clauses involved in checking
#    # for a winning sequence. The ways we are checking are scattered and
#    # not in sync
#    return false unless winning_deltas?(array)
#
#    win_type = winning_deltas.key(delta_values(array))
#    if win_type == :row
#      all_on_same_row?(array)
#    else
#      different_and_adjacent_rows?(array)
#    end
#  end
#
#  def winning_deltas?(array)
#    # This method checks if a potential winning sequence has the
#    # correct deltas between each contiguous square of the sequence when sorted
#    # The deltas are defined in an attribute of this class
#    deltas = sequence_deltas(array)
#    deltas.uniq.size == 1 && winning_deltas.values.include?(deltas.first.abs)
#  end
#
#  def sequence_deltas(sequence)
#    # Added this in to serve as a bridge between different use cases for
#    # checking the "delta" values between adjacent elements in a sorted array
#    ###### may want to move some of this functionality to a Module?
#    pairs = sequence.each_cons(2).to_a
#    pairs.map { |pair| pair.inject(&:-) }
#  end
#
#  def delta_values(winner)
#    pairs = winner.each_cons(2).to_a
#    pairs.map! { |pair| pair.inject(&:-) }
#    pairs.uniq.first.abs
#  end
#
#  def all_on_same_row?(sequence)
#    # Here we check if all the squares in a sequence
#    # are contained in the same row
#    sequence.map do |square|
#      get_row(square)
#    end.uniq.size == 1
#  end
#
#  def different_and_adjacent_rows?(sequence)
#    # This is used for all other winning sequence types
#    # (column, diagonals)
#    # where there should never be more than one square on the same row
#    row_numbers = sequence.map { |square| get_row(square) }
#    row_deltas = sequence_deltas(row_numbers)
#    row_deltas.uniq.size == 1 && row_deltas.first.abs == 1
#  end
#
#  def get_row(square)
#    # This helper method will, given a specific square number,
#    # return the row it would fall in, if we were to
#    # represent the board in a 2d matrix as opposed to a flat array
#    matrix = make_square_matrix
#    matrix.find_index { |row| row.include?(square) }
#  end
#
#  def make_square_matrix
#    squares.keys.each_slice(board.size).to_a
#  end