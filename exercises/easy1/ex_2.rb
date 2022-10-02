# Exercise 2
# What's the Output?
# Take a look at the following code:

class Pet
  attr_reader :name

  def initialize(name)
    @name = name.to_s
  end

  def to_s
    "My name is #{@name.upcase}."
  end
end

=begin
name = 'Fluffy'
fluffy = Pet.new(name)
puts fluffy.name
puts fluffy
puts fluffy.name
puts name
=end

# What output does this code print? Fix this class so that there are no 
# surprises waiting in store for the unsuspecting developer.

# Output
# 
# "Fluffy"
# "My name is FLUFFY"
# "FLUFFY"
# "FLUFFY"


# Further Exploration
# What would happen in this case?

name = 42
fluffy = Pet.new(name)
name += 1
puts fluffy.name
puts fluffy
puts fluffy.name
puts name

# Output
#
# 42
# "My name is 42"
# 42
# 43

# This code "works" because of that mysterious to_s call in Pet#initialize. 
# However, that doesn't explain why this code produces the result it does. Can you?

# The to_s call allows the `puts fluffy` expression to output a meaningful value; without it, the object details for the  
# instance of the Pet object represented by `fluffy` would be the output
# For the values 42 and 43, however, the Pet#to_s method is not invoked, as 42 and 43 are from the Integer class

# In terms of why the example "works" even if we include @name!upcase in the Pet#to_s method:
# When the value we pass in for the `name` argument to `Pet#new` is anything other than a string, `name#to_s` within
# the `initialize` constructor method in the Pet class definition returns a new string object, rather than the original object
# passed in. Therefore `@name.upcase!` mutates a separate object than the integer object pointed to by the `name` local variable
# that is outside the `Pet` class definition.