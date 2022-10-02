#1
=begin
class Cat
  attr_reader :name
  @@total_cats = 0

  def initialize(name)
    @name = name
    @@total_cats += 1
  end

  def jump
    "#{name} is jumping!"
  end

  def self.total_cats
    @@total_cats
  end

  def to_s
    @name
  end
end

mitzi = Cat.new('Mitzi')
p mitzi.jump # => "Mitzi is jumping!"
p Cat.total_cats # => 1
p "The cat's name is #{mitzi}" # => "The cat's name is Mitzi"


#2
class Student
  attr_accessor :grade
  def initialize(name)
    self.name = name
    @grade = nil
  end
end

ade = Student.new('Adewale')
p ade # => #<Student:0x00000002a88ef8 @grade=nil, @name="Adewale">


#3
class Student
  # assume that this code includes an appropriate #initialize method
  attr_accessor :name, :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

end

jon = Student.new('John', 22)
p jon.name # => 'John'
jon.name = 'Jon'
jon.grade = 'B'
p jon.grade # => 'B'
p jon.name


#4
class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  # We don't need to do this if we just change the #speak method. 
  # If we did want to add this #name method, we could then remove the attr_accessor method
  #def name
  #  @name
  #end

  def speak
    "#{name} is speaking."
  end
end

class Knight < Character
  def name
    "Sir " + super
  end
end

sir_gallant = Knight.new("Gallant")
p sir_gallant.name # => "Sir Gallant"
p sir_gallant.speak # => "Sir Gallant is speaking."



#5
class Character
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def speak
    "#{@name} is speaking."
  end
end

class Thief < Character
  def speak
    "#{name} is whispering..."
  end
end

sneak = Thief.new("Sneak")
p sneak.name # => "Sneak"
p sneak.speak # => "Sneak is whispering..."



#6
class FarmAnimal
  def speak
    "#{self.class} says "
  end
end

class Sheep < FarmAnimal
  def speak
    super + "baa!"
  end
end

class Lamb < Sheep
  def speak
    super + "baaaaaaa!"
  end
end

class Cow < FarmAnimal
  def speak
    super + "mooooooo!"
  end
end

p Sheep.new.speak # => "Sheep says baa!"
p Lamb.new.speak # => "Lamb says baa!baaaaaaa!"
p Cow.new.speak # => "Cow says mooooooo!"


=end
# 8
class Person
  def initialize(name)
    @name = name
  end
end

class Cat
  def initialize(name, owner)
    @name = name
    @owner = owner
  end
end

sara = Person.new("Sara")
fluffy = Cat.new("Fluffy", sara)

# Identify all custom defined objects that act as collaborator objects within the code. Select all that apply.

# Person