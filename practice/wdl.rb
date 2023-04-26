require "pry-byebug"

module Displayable
  def draw_board
    squares.each do |row|
      display_row(row)
    end
  end

  def display_row(row)
    draw_border

    self[row].each do |square|
      #binding.pry
      puts "| "
      square.draw
      puts "| "
    end

    draw_border
  end

  def draw_border
    puts '-----'
  end

end 

class Board
  include Displayable

  attr_accessor :squares
  
  def initialize
    @squares = Array.new(5) { Array.new(5) { Square.new} }
  end

  def [](index)
    squares[index]
  end

  def []=(index, value)
    squares[index] = value
  end
end

class Square
  attr_accessor :letter

  def initialize
    @letter = ' '
  end

  def draw
    puts ' --- '
    #puts '|   |'
    puts "| #{@letter} |"
    #puts '|   |'
    puts ' --- '
  end
end

class GameEngine
  attr_accessor :board

  def initialize
    @board = Board.new
  end
end

game = GameEngine.new
game.board[0][0].letter = 't'
game.board[0][1].letter = 'r'
game.board[0][2].letter = 'a'
game.board[0][3].letter = 'i'
game.board[0][4].letter = 'n'
game.board.display_row(0)