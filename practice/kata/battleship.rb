# Battleship field validator II
# Description:
# 
# Write a method that takes a field for well-known board game "Battleship" as an argument 
# and returns true if it has a valid disposition of ships, false otherwise. 
# Argument is guaranteed to be 10*10 two-dimension array. 
# Elements in the array are numbers, 0 if the cell is free and 1 if occupied by ship.
# 
# Battleship (also Battleships or Sea Battle) is a guessing game for two players. 
# Each player has a 10x10 grid containing several "ships" and objective is to destroy enemy's 
# forces by targetting individual cells on his field. The ship occupies one or more cells in the grid. 
# Size and number of ships may differ from version to version. In this kata we will use Soviet/Russian version of the game.
# 
# Before the game begins, players set up the board and place the ships accordingly to the following rules:
# 
# There must be single battleship (size of 4 cells), 2 cruisers (size 3), 
# 3 destroyers (size 2) and 4 submarines (size 1). Any additional ships are not allowed, as well as missing ships.
# Each ship must be a straight line, except for submarines, which are just single cell.
# The ship cannot overlap, but can be contact with any other ship.
# The description likes Battleship field validator Kata, the only difference is the rule 3.
# 
# This is all you need to solve this kata. If you're interested in more information about the game, visit this link.


# >>
# Nouns: game, players, ships, ship type, cell, cell value, straight line
# Verbs: overlap, contact

# classes
# BattleshipGame
#   attributes: board (2-d array), players
#   collaborators: Board
# Board
#   attributes: cells (2-d array)
#   collaborators: Ship
# Ship
#   attributes: size


# Will not implement all functionality needed for the actual game - in particular, support for "players". This is not
# necessary to solve this kata so will exclude.
# Will create a series of methods for Board that validate the board status
# One of the trickier tasks will be identifying the ships present on a given board

class BattleshipGame
end

class Board
  # hash with key = length of ship, value = count of number of ships with that length
  VALID_SHIPS = {4 => 1, 3 => 2, 2 => 3, 1 => 4 }

  def validate_battlefield(battle_field)
    # Two criteria to check:
    #   1. the counts of each ship length on the battlefield matches the valid ships hash
    #   2. none of those ships "overlap"
    ships = find_ships
    
    ships == VALID_SHIPS && 
  end

  def find_ships
    # returns a hash containing the count of each length of ship (keys = lengths, values = counts)
  end
end

class Ship
end


example = [[1, 0, 0, 0, 0, 1, 1, 0, 0, 0],
      		 [1, 0, 1, 0, 0, 0, 0, 0, 1, 0],
      		 [1, 0, 1, 0, 1, 1, 1, 0, 1, 0],
      		 [1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      		 [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
      		 [0, 0, 0, 0, 1, 1, 1, 0, 0, 0],
      		 [0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
      		 [0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
      		 [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
      		 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]