# Exercise 1
# Given the below usage of the Person class, code the class definition.
=begin
class Person
  attr_accessor :name

  def initialize(name)
    @name = name
  end
end

bob = Person.new('bob')
bob.name                  # => 'bob'
name = 'Robert'
bob.name                  # => 'Robert'

# Exercise 2
# Modify the class definition from above to facilitate the following methods. Note that there is no name= setter method now.

class Person
  attr_accessor :first_name, :last_name

  def initialize(fname,lname='')
    @first_name = fname
    @last_name = lname
  end
  
  def name
    @last_name.empty? ? @first_name : "#{@first_name} #{@last_name}"
  end

end


bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'


# Exercise 3
# Now create a smart name= method that can take just a first name or a full name, 
# and knows how to set the first_name and last_name appropriately.

class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  private

  def parse_full_name(full_name)
    names = full_name.split
    @first_name = names.first
    @last_name = names.size > 1 ? names.last : ''
  end
end


bob = Person.new('Robert')
bob.name                  # => 'Robert'
bob.first_name            # => 'Robert'
bob.last_name             # => ''
bob.last_name = 'Smith'
bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
bob.first_name            # => 'John'
bob.last_name             # => 'Adams'

=end

# Exercise 4
# Using the class definition from step #3, let's create a few more people -- that is, Person objects.

class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def name=(full_name)
    parse_full_name(full_name)
  end

  def to_s
    name
  end


  def ==(other)
    self.first_name == other.first_name && self.last_name == other.last_name
  end

  private

  def parse_full_name(full_name)
    names = full_name.split
    @first_name = names.first
    @last_name = names.size > 1 ? names.last : ''
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

bob == rob

# Exercise 5
# Continuing with our Person class definition, what does the below print out?

bob = Person.new('Robert Smith')
puts "The person's name is #{bob}"

# This will output the string representation of the object identifier, as determined by the standard library #to_s method
# We could make the output more reader friendly by implementing an override for the #to_s method within the Person class
