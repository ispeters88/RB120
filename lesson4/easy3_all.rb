=begin
# Question 1
# If we have this code:

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

# What happens in each of the following cases:

# case 1:

hello = Hello.new
hello.hi

# > "Hello" 

# case 2:

hello = Hello.new
hello.bye

# > Exception raised: NoMethodError
#     * The #bye method is not defined for either the Hello class or any of its superclasses
#       It is defined for the Goodbye class but Hello does not have access to that

# case 3:

hello = Hello.new
hello.greet

# > Exception raised: ArgumentError
#     * The Greeting#greet method expects 1 argument, but we are giving it 0

# case 4:

hello = Hello.new
hello.greet("Goodbye")

# "Goodbye"

# case 5:

Hello.hi

# > Exception raised: NoMethodError
#   * There is no class method #hi for class Hello, which is what we are attempting to call in this case 


# Question 2
# In the last question we had the following classes:

class Greeting
  def greet(message)
    puts message
  end

  def self.greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end

  def self.hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.hi

# If we call Hello.hi we get an error message. How would you fix this?
#   > Define a class method #hi. We can do this as included above


# Question 3
# When objects are created they are a separate realization of a particular class.

# Given the class below, how do we create two different instances of this class with separate names and ages?

class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

cat1 = AngryCat.new(5,"CatOne")
cat2 = AngryCat.new(6, "CatTwo")

p cat1
p cat2


# Question 4
# Given the class below, if we created a new instance of the class and then called to_s on that instance we would get something like "#<Cat:0x007ff39b356d30>"

class Cat
  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{@type} cat"
  end

end
# How could we go about changing the to_s output on this method to look like this: 
# I am a tabby cat? (this is assuming that "tabby" is the type we passed in during initialization).

my_cat = Cat.new('tabby')
puts my_cat

# > Define a custom to_s method within the class, as included above


# Question 5
# If I have the following class:

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

# What would happen if I called the methods like shown below?

tv = Television.new
tv.manufacturer
# > NoMethodError
tv.model
# > The results of whatever method logic is defined in `Television#model`
Television.manufacturer
# > The results of whatever method logic is defined in `Television::manufacturer`
Television.model
# > NoMethodError



# Question 6
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

# In the make_one_year_older method we have used self. What is another way we could write
# this method so we don't have to use the self prefix?

# We could use an @ character

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age = 0
  end

  def make_one_year_older
    @age += 1
  end
end

cat = Cat.new('tabby')
3.times { cat.make_one_year_older }
puts "The #{cat.type} cat is now #{cat.age}"

=end

# Question 7
# What is used in this class but doesn't add any value?

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"
  end

end

# > The return keyword. This is implied as the final expressioin in a method and doesn't add anything