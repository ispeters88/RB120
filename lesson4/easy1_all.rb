=begin 

# Question 1
# Which of the following are objects in Ruby? If they are objects, how can you find out what class they belong to?
# 
# true - object, belongs to TrueClass class
# "hello" - object, belongs to String class
# [1, 2, 3, "happy days"] - object, belongs to Array class
# 142 - object, belongs to Integer class

# Can use #class to confirm which class an object belongs to


# Question 2
# If we have a Car class and a Truck class and we want to be able to go_fast, 
# how can we add the ability for them to go_fast using the module Speed? 
# How can you check if your Car or Truck can now go fast?


module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

# 1. mixin the Speed module to both Car and Truck classes

class Car
  include Speed

  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed

  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

# 2. instantiate objects within the Truck and the Car classes, and then call the go_fast method:

car = Car.new
truck = Truck.new

car.go_fast
truck.go_fast

# Question 3
# In the last question we had a module called Speed which contained a go_fast method. 
# We included this module in the Car class as shown below.


module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end


# When we called the go_fast method from an instance of the Car class (as shown below) 
# you might have noticed that the string printed when we go fast 
# includes the name of the type of vehicle we are using. How is this done?

small_car = Car.new
small_car.go_fast
#I am a Car and going super fast!


# > The call to self.class returns the class of the object pointed to by the small_car variable. This object
# is an instance of the Car class.


# If we have a class AngryCat how do we create a new instance of this class?

# The AngryCat class might look something like this:

class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end

mad_cat = AngryCat.new



# Question 5

# Which of these two classes has an instance variable and how do you know?

  class Fruit
    def initialize(name)
      name = name
    end
  end
  
  class Pizza
    def initialize(name)
      @name = name
    end
  end

# The `Pizza` class has an instance variable, name. Instance variables are prefixed with a @ character

# Question 6

# What could we add to the class below to access the instance variable @volume?

class Cube
  attr_accessor :volume
  def initialize(volume)
    @volume = volume
  end
end

# > The answer depends on what sort of access we are looking to have - read/write/both, 
# and who/what should have that sort of access
# > Here we have added public read + write access, with the attr_accessor method

# Question 7
# What is the default return value of to_s when invoked on an object? 
# Where could you go to find out if you want to be sure?

# > The default return value of to_s is a string representation of the calling object - specifically, 
# the name of the object's class and an encoded display of the object ID
# We can consult the ruby documentation to be sure. #to_s is an instance method for the Object class

# Question 8
# If we have a class such as the one below:


class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# You can see in the make_one_year_older method we have used self. What does self refer to here?

# > This refers to the object calling the instance method #make_one_year_older

# Question 9
# If we have a class such as the one below:

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# In the name of the cats_count method we have used self. What does self refer to in this context?

# > Self in this context refers to the Cat class itself. A method defined with `self.` as the prefix to the method name
# is a class method - these get called on the class name, as opposed to a specific instance of the class

=end
# Question 10
# If we have the class below, what would you need to call to create a new instance of this class.

class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

# > We would need to call the class method ::new with two arguments - a "color" and a "material". For example:
#     my_bag = Bag.new("black", "leather")