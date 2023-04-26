=begin
# Question 1
#You are given the following code:

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

# What is the result of executing the following code:

oracle = Oracle.new
oracle.predict_the_future

# > A string value will be returned. It will be the concatenation of "You will " and one of the three
# strings defined in the array in the `Oracle#choices` method - chosen at random
# Nothing will be output

# Question 2
# We have an Oracle class and a RoadTrip class that inherits from the Oracle class.

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

# What is the result of the following:

trip = RoadTrip.new
trip.predict_the_future

# > Similarly the previous question, a string value will be returned that contains "You will {something}", where
# "something" is a phrase chosen at random. This time, however, the phrase will come from the array within the instance
# method definition for #choices that is included in the RoadTrip class
# This is explained by the method lookup path Ruby uses: the calling object, `trip`, is an instance of the RoadTrip class
# When `#choices` is called, the calling object's class is checked for this method; it is found, so it is
# invoked. if this method had not been found in the RoadTrip class, the parent class, `Oracle`, would have been
# checked next


# Question 3
# How do you find where Ruby will look for a method when that method is called? How can you find an object's ancestors?

module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end
  
# What is the lookup chain for Orange and HotSauce?

# > We can use `#ancestors` to return an array containing the ancestors/method lookup path for a class

p Orange.ancestors # == [Orange, Taste, Object, Kernel, BasicObject]
p HotSauce.ancestors # == [HotSauce, Taste, Object, Kernel, BasicObject]


# Question 4
# What could you add to this class to simplify it and remove two methods
# from the class definition while still maintaining the same functionality?

class BeesWax
  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def type=(t)
    @type = t
  end

  def describe_type
    puts "I am a #{@type} of Bees Wax"
  end
end

# > We could add the attr_accessor method. This builds both the getter `#type` as well as the setter
# `#type=` methods: 

class BeesWax
  attr_accessor :type
  
  def initialize(type)
    @type = type
  end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end


# Question 5
# There are a number of variables listed below. 
# What are the different types and how do you know which is which?

excited_dog = "excited dog"
@excited_dog = "excited dog"
@@excited_dog = "excited dog"

# > We can tell which is which by the prefix character(s) `@``, or lack thereof:
#   1. excited_dog is alocal variable. Local vars have no `@` prefix
#   2. @excited_dog is an instance variable. IVars have one `@` as a prefix
#   3. @@excited_dog is a class variable. Class vars have two `@` characters as their prefix


# Question 6
# If I have the following class:

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

# Which one of these is a class method (if any) and how do you know? How would you call a class method?

# > `#manufacturer` is a class method. This is denoted by the name of the method beginning with `self`. 
# We can call this method on the class name itself, ie. `Television.manufacturer`. This contrasts
# with instance methods, which must be called on a specific instance of the class:
#     my_tv = Television.new
#     my_tv.model


# Question 7
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

# Explain what the @@cats_count variable does and how it works.
# What code would you need to write to test your theory?

# > `@@cats_count` is a class variable, and it keeps track of the number of objects instantiated for the `Cat` class
# This is done by incrementing the variable by one within the constructor method `initialize`
# This is a typical use case for a CVar - the number of cats is indepdendent of any one specific `Cat` object, 
# so it makes sense to keep track of the variable at the class level, rather than storing it to the state of
# one specific instance of the class.
# To test this theory, we can use

calico = Cat.new('calico')
tabby = Cat.new('tabby')
barn = Cat.new('barn')

p Cat.cats_count


# Question 8
# If we have this class:


class Game
  def play
    "Start the game!"
  end
end
And another class:

class Bingo
  def rules_of_play
    #rules of play
  end
end

# What can we add to the Bingo class to allow it to inherit the play method from the Game class?

# > We can defined the `Bingo` class to be a subclass of `Game`:

class Game
  def play
    "Start the game!"
  end
end
And another class:

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end



# Question 9

# If we have this class:

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

# What would happen if we added a play method to the Bingo class, 
# keeping in mind that there is already a method of this name in the Game class that the Bingo class inherits from.

# > The `play` method within the Bingo class would take precedence over `Game#play`, for `Bingo` objects:

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end

  def play
    "Good luck in bingo!"
  end
end

bingo_game = Bingo.new
p bingo_game.play


=end
# Question 10

# What are the benefits of using Object Oriented Programming in Ruby? Think of as many as you can.

# > Benefits:
#     1. Encapsulation
#     2. Polymorphism
#     3. Minimizing code complexity, code maintenance
#     4. Better represent real world concepts
#     5. More readable code

# LS answer:

# * Creating objects allows programmers to think more abstractly about the code they are writing.
# * Objects are represented by nouns so are easier to conceptualize.
# * It allows us to only expose functionality to the parts of code that need it, meaning namespace issues are much harder to come across.
# * It allows us to easily give functionality to different parts of an application without duplication.
# * We can build applications faster as we can reuse pre-written code.
# * As the software becomes more complex this complexity can be more easily managed.