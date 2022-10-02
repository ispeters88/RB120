# Exercise 9
# Nobility

# Now that we have a Walkable module, we are given a new challenge. 
# Apparently some of our users are nobility, and the regular way of walking simply isn't good enough. 
# Nobility need to strut.
# 
# We need a new class Noble that shows the title and name when walk is called:

=begin
module Movable
  def walk
    if self.is_a?(Noble)
      puts "#{title} #{name} #{gait} forward"
    else
      puts "#{name} #{gait} forward"
    end
  end
end

class Noble
  include Movable
  attr_reader :name, :title

  def initialize(name, title)
    @name = name
    @title = title
  end

  def gait
    "struts"
  end
end


byron = Noble.new("Byron", "Lord")
byron.walk
# => "Lord Byron struts forward"

# We must have access to both name and title because they are needed for other purposes that we aren't showing here.

p byron.name
# => "Byron"
p byron.title
# => "Lord"

class Person
  include Movable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  include Movable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  include Movable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "runs"
  end
end


mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"


=end
# Further Exploration
# This exercise can be solved in a similar manner by using inheritance; a Noble is a Person, 
# and a Cheetah is a Cat, and both Persons and Cats are Animals. 
# What changes would you need to make to this program to establish these relationships 
# and eliminate the two duplicated #to_s methods?
# 
# Is to_s the best way to provide the name and title functionality we needed for this exercise? 
# Might it be better to create either a different name method (or say a new full_name method) that automatically accesses 
# @title and @name? There are tradeoffs with each choice -- they are worth considering.

module Movable
  def walk
    if self.is_a?(Noble)
      puts "#{title} #{name} #{gait} forward"
    else
      puts "#{name} #{gait} forward"
    end
  end
end

class Animal
  def initialize(name)
    @name = name
  end
end

class Person < Animal
  include Movable
  attr_reader :name

  private

  def gait
    "strolls"
  end
end

class Noble < Person
  attr_reader :name, :title

  def initialize(name, title)
    super(name)
    @title = title
  end

  def gait
    "struts"
  end
end

class Cat < Animal
  attr_reader :name

  private

  def gait
    "saunters"
  end
end

class Cheetah < Cat
  attr_reader :name

  private

  def gait
    "runs"
  end
end

mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"

byron = Noble.new("Byron", "Lord")
byron.walk
# => "Lord Byron struts forward"