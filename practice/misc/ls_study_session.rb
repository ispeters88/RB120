# Compare FishAliens

# Modify the given code to achieve the expected output

=begin
class FishAliens
  def initialize(age, name)
    @age = age
    @name = name
  end

  def ==(other)
    age == other.age
  end
    
  protected

  attr_reader :age, :name
end

class Jellyfish < FishAliens; end

class OctoAlien < FishAliens; end

fish = Jellyfish.new(100, "Fish")
alien = OctoAlien.new(100, "Roger")

                      # Expected output:
p fish == alien       # => false

# Attack

class Barbarian
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end

  def attacks
    puts "attacks!"
  end
end

class Monster
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end

  def attacks
    puts "attacks!"
  end
end


conan = Barbarian.new("Conan", 50)
zombie = Monster.new("Fred", 100)

conan.attacks
zombie.attacks

# We expected the code to output
#=> "attacks!"
#=> "attacks!"

#=> Instead we raise an error.  What would be the best way to fix this implementation? Why?
# > We did not implement the #attacks method. Since these are separate classes with no inheritance hierarchy, we
# should implement this method in both classes.


# Animal Sounds
# What does the above code output? How can you fix it so we get the desired results?

class Animal
  @@sound = nil
  
  def initialize(name)
    @name = name
  end
  
  def speak
    puts "#{@name} says #{@@sound}"
  end
end

class Dog < Animal
  def initialize(name)
    super
    @@sound = 'Woof Woof!'
  end
end

class Cat < Animal
  def initialize(name)
    super
    @@sound = 'Meow!'
  end
end
  
fido = Dog.new('Fido')
felix = Cat.new('Felix')

                    # Expected Output:
fido.speak          # => Fido says Woof Woof!
felix.speak         # => Felix says Meow!

# > Class variables generally shouldn't be modified with inheritance involved. The way these are resolved is sequential
# in the program file; this means that the last value set for the class variable is the one that it is set to by the time
# the #speak methods are called


# Shopping Basket

# GOAL:
# Create an application that allows you to add "products" to a shopping basket.
# So define the CLASSES for each product (make 3).
# Products should have a name and a price (an integer).
# Add products to the shopping basket
# At checkout calculate total_price of ALL products.

class ShoppingBasket
  attr_accessor :basket

  def initialize
    @basket = Array.new
  end

  def add_to_basket(item)
    basket << item
  end
end

class CheckoutDesk
  def checkout(cart)
    @price = calculate_price(cart)
    display_price
  end

  def calculate_price(cart)
    cart.basket.inject(0) { |total, item| total + item.price }
  end

  def display_price
    puts "Your total bill today is #{price}"
  end

  private

  attr_reader :price
end

class Products
  attr_reader :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end

class Pasta < Products
  def initialize(name, price)
    super
  end
end

class Yogurt < Products
  def initialize(name, price)
    super
  end
end

class Eggs < Products
  def initialize(name, price)
    super
  end
end

my_cart = ShoppingBasket.new
cavatappi = Pasta.new("1 LB Cavatappi", 3)
yogurt = Yogurt.new("Skyr", 6)
eggs = Eggs.new("Rhody Fresh", 4)

[cavatappi, yogurt, eggs].each do |item|
  my_cart.add_to_basket(item)
end

register = CheckoutDesk.new
register.checkout(my_cart)



# Player Characters

# Without running the code, determine what the output will be.

class PlayerCharacter
  attr_reader :name 
  def initialize(name, hitpoints)
    @name = name
    @hitpoints = hitpoints
  end
end

class Barbarian < PlayerCharacter
   def initialize(name, hitpoints)
    super(name, hitpoints)
   end

end

class Summoner < PlayerCharacter
  # all Summoners have 100 manapoints
 
  def initialize(name, hitpoints)
    super(name, hitpoints, manapoints)
  end
  
end

conan = Barbarian.new("Conan", 50)
gandolf = Summoner.new("Gandolf", 25)

p conan.rage # true
p gandolf.manapoints # => 100

p gandolf.hitpoints #25


# > This will raise an exception because the variable `manapoints` that we are passing into the `super` keyword
# within the Summoner#initialize method, does not exist. 
# However, even if we were to add it:
# > This would still raise an ArgumentError exception - since we are passing in 3 arguments to `super` in the constructor
# method within the Summoner class, whereas the PlayerCharacter class whose constructor receives these arguments
# only expects 2



# Dictionary
# Implement the following classes such that we get the desired output

require "pry-byebug"

class Dictionary
  attr_accessor :words

  def initialize
    @words = []
  end

  def <<(word)
    words << word
    words.sort!
  end

  def by_letter(letter)
    words.select { |word| word.name.start_with?(letter.upcase)}
  end
end

class Word
  include Comparable
  attr_reader :name

  def initialize(name, definition)
    @name = name
    @definition = definition
  end

  def to_s
    "#{name}"
  end

  def <=>(other)
    name <=> other.name
  end
end

apple = Word.new("Apple", "The round fruit of a tree of the rose family")
banana = Word.new("Banana", "A long curved fruit which grows in clusters and has soft pulpy flesh and yellow skin when ripe")
blueberry = Word.new("Blueberry", "The small sweet blue-black edible berry of the blueberry plant")
cherry = Word.new("Cherry", "A small, round stone fruit that is typically bright or dark red")

dictionary = Dictionary.new

dictionary << apple
dictionary << banana
dictionary << cherry
dictionary << blueberry

puts dictionary.words
# Apple
# Banana
# Blueberry
# Cherry


puts dictionary.by_letter("a")
# Apple


puts dictionary.by_letter("B")
# Banana
# Blueberry

# Library

# Given the two classes defined below, implement the necessary methods to get the expected results.

class Library
  attr_accessor :books

  def initialize
    @books = []
  end

  def <<(book)
    books << book
  end

  def checkout_book(title, author)
    book = @books.find { |book| book.title == title && book.author == author }
    if checked_out
      @books.delete(checked_out)
      p checked_out
    else
      puts "The library does not have that book"
    end
  end
end

class Book
  attr_reader :title, :author

  def initialize(title, author)
    @title = title
    @author = author
  end

  def to_s
    "#{title} by #{author}"
  end
end

lib = Library.new

lib << Book.new('Great Expectations', 'Charles Dickens')
lib << Book.new('Romeo and Juliet', 'William Shakespeare')
lib << Book.new('Ulysses', 'James Joyce')

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Romeo and Juliet by William Shakespeare
  # => Ulysses by James Joyce

lib.checkout_book('Romeo and Juliet', 'William Shakespeare')
  # deletes the Romeo and Juliet book object from @books and returns it
  # i.e. returns #<Book:0x0000558ee2ffcf50 @title="Romeo and Juliet", @author="William Shakespeare">

lib.books.each { |book| puts book }
  # => Great Expectations by Charles Dickens
  # => Ulysses by James Joyce

lib.checkout_book('The Odyssey', 'Homer')
  # => The library does not have that book



# Constants
LOCATION = self

class Parent
  #LOCATION = self
end

module A
  module B
    #LOCATION = self
    module C
      class Child < Parent
        #LOCATION = self
        def where_is_the_constant
          LOCATION
        end
      end
    end
  end
end

instance = A::B::C::Child.new
puts instance.where_is_the_constant

# What does the last line of code output?
# > The output is `A::B::C::Child`

# Comment out LOCATION in Child, what is output now?
# > The output is now `A::B`

# Comment out LOCATION in Module B, what is output now?
# > The output is now `Parent`

# Comment out LOCATION in Parent, what is output now?
# > The output is now `main` (?)

=end

# Juniors

# Implement the given classes so that we get the expected results

class ClassLevel
  attr_accessor :level, :members

  def initialize(level)
    @level = level
    @members = []
  end

  def <<(student)
    if members.include?(student)
      puts "That student is already added"
    else
      self.members << student
    end
  end
end

class Student
  attr_accessor :name, :id, :gpa
  
  def initialize(name, id, gpa)
    @name = name
    @id = id
    @gpa = gpa
  end

  def to_s
    %(       #{"=" * 12}
      "Name: #{name}"
      "Id: #{id}"
      "GPA: #{gpa}"
      #{"=" * 12})
  end

  def ==(other)
    id <=> other.id
  end

  def <(other)
  end

  def >(other)
  end

  
end

juniors = ClassLevel.new('Juniors')

anna_a = Student.new('Anna', '123-11-123', 3.85)
bob = Student.new('Bob', '555-44-555', 3.23)
chris = Student.new('Chris', '321-99-321', 2.98)
david = Student.new('David', '987-00-987', 3.12)
anna_b = Student.new('Anna', '543-33-543', 3.76)

juniors << anna_a
juniors << bob
juniors << chris
juniors << david
juniors << anna_b

juniors << anna_a
  # => "That student is already added"

puts anna_a

puts juniors.members
  # => ===========
  # => Name: Anna
  # => Id: XXX-XX-123
  # => GPA: 3.85
  # => ==========
  # => ...etc (for each student)

p anna_a == anna_b 
  # => false

p david > chris
  # => true

juniors.valedictorian
  # => "Anna has the highest GPA of 3.85"
