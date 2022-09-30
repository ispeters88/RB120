# Exercise 1

# Class based inheritance works great when it's used to model hierarchical domains. 
# Let's take a look at a few practice problems. 
# Suppose we're building a software system for a pet hotel business, so our classes deal with pets.

# Given this class:

class Dog
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end


teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"
bully = Bulldog.new
puts bully.speak
puts bully.swim

# One problem is that we need to keep track of different breeds of dogs, since they have slightly different behaviors. 
# For example, bulldogs can't swim, but all other dogs can.

# Create a sub-class from Dog called Bulldog overriding the swim method to return "can't swim!"



# Exercise 2

# Let's create a few more methods for our Dog class.

class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end


class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    'meow!'
  end
end


# Create a new class called Cat, which can do everything a dog can, except swim or fetch. 
# Assume the methods do the exact same thing. Hint: don't just copy and paste all methods in Dog into Cat; 
# try to come up with some class hierarchy.


# Exercise 4
# What is the method lookup path and how is it important?

# The method lookup path is the hierarchical order that Ruby uses to determine which class it should reference for a method
# invocation, when the same method is defined in multiple classes. 
# Call the method Class::ancestors to list out the method lookup path/class hierarchy