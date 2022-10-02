# Exercise 8
# Rectangles and Squares

# Given the following class:

class Rectangle
  def initialize(height, width)
    @height = height
    @width = width
  end

  def area
    @height * @width
  end
end

class Square < Rectangle

  # def initialize(size)
  #   @height = size
  #   @width = size
  # end

  def initialize(size)
    super(size, size)
  end

end

# Write a class called Square that inherits from Rectangle, and is used like this:

square = Square.new(5)
puts "area of square = #{square.area}"

