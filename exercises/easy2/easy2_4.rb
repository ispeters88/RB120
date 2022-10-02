# Exercise 4
# Reverse Engineering

# Write a class that will display:

# ABC
# xyz

# when the following code is run:
#
# my_data = Transform.new('abc')
# puts my_data.uppercase
# puts Transform.lowercase('XYZ')


class Transform
  def initialize(str)
    @str = str
  end

  def self.lowercase(str)
    str.downcase
  end

  def uppercase
    @str.upcase
  end
end



my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')

# Further Exploration
# A class method is also, somewhat confusingly, called a "singleton method" 
# (the term is used in other contexts as well). 
# We don't recommend learning the details at this time - it may be more confusing than it is helpful - 
# but you should be aware that you may encounter this term.