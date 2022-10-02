# Exercise 3
# Complete The Program - Houses

# Assume you have the following code:


class House
  include Comparable
  attr_reader :price

  def initialize(price)
    @price = price
  end
  
  def <=>(other)
    price <=> other.price
  end


end

home1 = House.new(100_000)
home2 = House.new(150_000)
puts "Home 1 is cheaper" if home1 < home2
puts "Home 2 is more expensive" if home2 > home1


# and this output:
# 
# Home 1 is cheaper
# Home 2 is more expensive
# 
# Modify the House class so that the above program will work. You are permitted to define only one new method in House.

# Further Exploration
# Is the technique we employ here to make House objects comparable a good one? 
# (Hint: is there a natural way to compare Houses? Is price the only criteria you might use?) 
#
# > It could be confusing, or not entirely clear, that what is being compared is the price
# There are a number of different ways that we can compare houses - price, square footage, number of rooms - and different
# people will probably default to different options if asked to do a comparison. 


# What problems might you run into, if any? Can you think of any sort of classes where including Comparable is a good idea?

# > If we are exposing the comparison operators to user interface, we could run into errors where people attempt to compare
# attributes other than the ones we are providing comparison ability for.
# Classes that are always comparable and have a single specific attribute that makes sense to compare are good candidates 
# to mixin Comparable