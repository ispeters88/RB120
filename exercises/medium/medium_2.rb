# Fixed Array
# A fixed-length array is an array that always has a fixed number of elements. 
# Write a class that implements a fixed-length array, 
# and provides the necessary methods to support the following code:

class FixedArray
  def initialize(size)
    @elements = Array.new(size)
  end

  def [](index)
    if index < @elements.size
      @elements[index]
    else
      raise IndexError
    end
    # much simpler option: @elements.fetch(index)
  end

  def []=(index, value)
    self[index]
    @elements[index] = value
  end

  def to_a
    #@elements.to_a
    @elements.clone
    # reasoning behind #clone is to ensure no code outside the class mutates our fixed array
  end

  def to_s
    # @elements.to_s
    @elements.to_a.to_s
    # same idea - we want to protect or encapsulate the attribute
  end
end

fixed_array = FixedArray.new(5)

puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end

# The above code should output true 16 times.

