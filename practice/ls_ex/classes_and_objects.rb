=begin
# Ex 1

class ExOne
  def initialize(items)
    @items = []
    items.each { |item| @items << item }
  end

  def display_classes
    @items.each { |item| puts item.class }
  end
end

exOne = ExOne.new(["Hello", 5, [1, 2, 3]])
exOne.display_classes

# Ex 2 + (including 2nd set of exercises)

module Walkable
  def walk
    puts "Let's go for a walk!"
  end
end


class Cat
  include Walkable

  @@cat_count = 0

  def initialize(name)
    @name = name
    increase_cat_count
  end

  def increase_cat_count
    @@cat_count += 1
  end

  def self.total
    @@cat_count
  end

  def introduce
    puts "Hello! My name is #{name}"
  end

  def rename(new_name)
    @name = new_name
  end

  def to_s
    "#{name}, the cat"
  end

  def self.generic_greeting
    puts "Hello! I'm a cat!"
  end

  def identify
    self
  end

  private

  attr_accessor :name
end

kitty = Cat.new("Fluffy")
kitty.introduce
kitty.rename("Luna")
kitty.introduce
kitty.walk
Cat.generic_greeting
p kitty.identify
puts Cat.total
kitty2 = Cat.new("Scratcher")
puts Cat.total
kitty3 = Cat.new("Boss")
puts Cat.total



# Set 2, Ex 8-10

# Public Secret

class Person
  attr_accessor :secret
end

person1 = Person.new
person1.secret = 'Shh...this is a secret!'
puts person1.secret



class Person
  attr_writer :secret

  def share_secret
    puts secret
  end

  private

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'
person1.share_secret



=end


class Person
  attr_writer :secret

  def compare_secret(other)
    secret == other.secret
  end

  protected

  attr_reader :secret
end

person1 = Person.new
person1.secret = 'Shh.. this is a secret!'

person2 = Person.new
person2.secret = 'Shh.. this is a different secret!'

puts person1.compare_secret(person2)