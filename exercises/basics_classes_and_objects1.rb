# Exercise 1

puts "Hello"
puts 5
puts [1, 2, 3]

puts "Hello".class
puts 5.class
puts [1, 2, 3].class

# Exercise 2

class Cat
end

# Exercise 3

kitty = Cat.new

# Exercise 4

class Cat
  def initialize
    puts "I'm a cat!"
  end
end

# Exercise 5

class Cat
  def initialize(name)
    @name = name
    puts "Hello! My name is #{@name}!"
  end
end

kitty = Cat.new("Sophie")

# Exercise 6

class Cat
  def initialize(name)
    @name = name
    puts "--------"
  end

  def greet
    puts "Hello! My name is #{@name}!"
  end
end

kitty = Cat.new("Sophie")
kitty.greet

# Exercise 7
class Cat
  attr_reader :name

  def initialize(name)
    @name = name
    puts "--------"
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new("Sophie")
kitty.greet

# Exercise 8

class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
    puts "--------"
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new("Sophie")
kitty.name = "Luna"
kitty.greet

# Exercise 9
# > nested in exercise 8

# Exercise 10
module Walkable
  def walk
    puts "Lets go for a walk!"
  end
end

class Cat
  include Walkable
  attr_accessor :name

  def initialize(name)
    @name = name
    puts "--------"
  end

  def greet
    puts "Hello! My name is #{name}!"
  end
end

kitty = Cat.new("Sophie")
kitty.name = "Luna"
kitty.greet
kitty.walk