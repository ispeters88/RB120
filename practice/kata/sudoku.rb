=begin

Given a Sudoku data structure with size NxN, N > 0 and √N == integer, 
write a method to validate if it has been filled out correctly.

The data structure is a multi-dimensional Array, i.e:

[
  [7,8,4,  1,5,9,  3,2,6],
  [5,3,9,  6,7,2,  8,4,1],
  [6,1,2,  4,3,8,  7,5,9],
  
  [9,2,8,  7,1,5,  4,6,3],
  [3,5,7,  8,4,6,  1,9,2],
  [4,6,1,  9,2,3,  5,8,7],
  
  [8,7,6,  3,9,4,  2,1,5],
  [2,4,3,  5,6,1,  9,7,8],
  [1,9,5,  2,8,7,  6,3,4]
]
Rules for validation

Data structure dimension: NxN where N > 0 and √N == integer
Rows may only contain integers: 1..N (N included)
Columns may only contain integers: 1..N (N included)
'Little squares' (3x3 in example above) may also only contain integers: 1..N (N included)

=end

# Nouns: Data structure, size, rows, columns, 'little square'
# Verbs: validate, contain

# Main class: Sudoku
#     > can have instance method : is_valid?
# Collaborator classes
#   1. row
#   2. column
#   3. 'little square'

require "pry-byebug"

class Sudoku
  def initialize(matrix)
    @matrix = matrix
    @rows = matrix.each_with_object([]) { |row, rows| rows << Row.new(row) }
    @columns = safe_transpose(matrix).each_with_object([]) { |col, cols| cols << Column.new(col) }
    build_little_squares
  end

  def safe_transpose(arr)
    begin
      arr.transpose
    rescue IndexError
      []
    end
  end

  def build_little_squares
    # Split the matrix into sets of rows the size of sqrt(N)
    # Iterate from 0 to sqrt(N) - on each iteration, i
    #   > Take the ith set of rows
    #   > Transpose it and take sets of rows the size of sqrt(N). 
    #     The transposition implies these "rows" are simply the columns from the original matrix
    #   > This produces a submatrix that has N values and represents a mini square from the original matrix
    #   > Add each submatrix to the `little_squares` IVar
    @little_squares = Array.new
    row_slices = @matrix.each_slice(get_root).to_a

    (0...get_root).each do |i|
      squares = safe_transpose(row_slices[i]).each_slice(get_root).to_a

      squares.each do |square|
        @little_squares << LittleSquare.new(square.flatten)
      end
    end
  end

  def valid?
    valid_dimensions? && all_groupings_valid?
  end

  def valid_dimensions?
     perfect_square? && square_dimensions?
  end

  def perfect_square?
    get_root ** 2 == @matrix.size
  end

  def square_dimensions?
    @matrix.map(&:size).all? do |row_size| 
      row_size == @matrix.size
    end
  end

  def all_groupings_valid?
    [@rows, @columns, @little_squares].all? do |grouping|
      grouping.all?(&:valid?)
    end
  end

  def get_root
    Math.sqrt(@matrix.size).to_i
  end
end

class Grouping
  def initialize(group)
    @values = group
  end

  def valid?
    @values.uniq.sort == (1..@values.size).to_a
  end
end

class Row < Grouping
  attr_reader :values
end

class Column < Grouping; end

class LittleSquare < Grouping; end

test1 = [
  [1,4, 2,3],
  [3,2, 4,1],
  [4,1, 3,2],
  [2,3, 1,4]
]

test2 = [
  [7,8,4, 1,5,9, 3,2,6],
  [5,3,9, 6,7,2, 8,4,1],
  [6,1,2, 4,3,8, 7,5,9],

  [9,2,8, 7,1,5, 4,6,3],
  [3,5,7, 8,4,6, 1,9,2],
  [4,6,1, 9,2,3, 5,8,7],
  
  [8,7,6, 3,9,4, 2,1,5],
  [2,4,3, 5,6,1, 9,7,8],
  [1,9,5, 2,8,7, 6,3,4]
]

test3 = [
  [0,2,3, 4,5,6, 7,8,9],
  [1,2,3, 4,5,6, 7,8,9],
  [1,2,3, 4,5,6, 7,8,9],
  
  [1,2,3, 4,5,6, 7,8,9],
  [1,2,3, 4,5,6, 7,8,9],
  [1,2,3, 4,5,6, 7,8,9],
  
  [1,2,3, 4,5,6, 7,8,9],
  [1,2,3, 4,5,6, 7,8,9],
  [1,2,3, 4,5,6, 7,8,9]
]


test4 = [
  [1,2,3,4,5],
  [1,2,3,4],
  [1,2,3,4],  
  [1]
]

sudo_1 = Sudoku.new(test1)
sudo_2 = Sudoku.new(test2)
sudo_3 = Sudoku.new(test3)
sudo_4 = Sudoku.new(test4)
p sudo_1.valid?
p sudo_2.valid?
p sudo_3.valid?
p sudo_4.valid?