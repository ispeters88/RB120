# Exercise 9
# Complete the Program - Cats!

# Consider the following program.

class Pet
  def initialize(name, age)
    @name = name
    @age = age
  end
end

class Cat < Pet
  def initialize(name, age, color)
    super(name, age)
    @color = color
  end

  def to_s
    "My cat #{@name} is #{@age} and has #{@color} fur"
  end
end

pudding = Cat.new('Pudding', 7, 'black and white')
butterscotch = Cat.new('Butterscotch', 10, 'tan and white')
puts pudding, butterscotch

# Update this code so that when you run it, you see the following output:

# My cat Pudding is 7 years old and has black and white fur.
# My cat Butterscotch is 10 years old and has tan and white fur.


# Further Exploration
# An alternative approach to this problem would be to modify the Pet class to accept a colors parameter. 
# If we did this, we wouldn't need to supply an initialize method for Cat.
# 
# Why would we be able to omit the initialize method? Would it be a good idea to modify Pet in this way? 
# Why or why not? How might you deal with some of the problems, if any, that might arise from modifying Pet?

# Answer
# We would not need to define an `initialize` method for `Pet` in this case because we can inherit the `color` attribute
# from `Pet`. 
# This might or might not be a good idea, depending on what sort of attribute essence we are looking to lend to 
# out `Pet` class. We might not want to supply other subclasses of `Pet` with the `color` attribute.

# We could work around this by overrriding the accessor methods for subclasses such that objects of those classes could
# not access the `color` attribute.