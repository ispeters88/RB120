=begin

module MyModule
end

class VariableMaster
end

class VariableTesting < VariableMaster
  include MyModule

  attr_accessor :var_one, :var_two

  def initialize
    var_one = 1
    var_two = 'two'
  end
end

var_test = VariableTesting.new
p var_test

def var_test.instance_method
  "This is an instance method created outside a class definition"
end

p var_test.instance_method
p VariableTesting.ancestors



class Ideology
  CORRUPTION = 'Total'
end

class Capitalism < Ideology
  def initialize
    @wealth = 'some'
  end
end

class Socialism < Ideology
  def initialize
    @wealth = 'none'
  end
end

=end


=begin

Above I have defined a class, `Superhero`. The values assigned to the local variables `batman` and `storm` on lines
`3-4` are instances of this class, which are instantiated on these linesusing the Ruby constructor method `new`,
with two arguments in each case: a name, and a superpower. Both arguments are in the form of `String` objects.

These two arguments are passed in to the `initialize` method, which is called by invoking `Superhero.new`, and their values
are then assigned to the instance variables `@name` and `@power` for the object instance. These values become a part of
each object's state, which is distinct from the state of any other object for the `Superhero` class.

Three distinct instance methods are called on lines `5-10`: `name`, `use_powers`, and `exclaim`. The first two, `name` and 
`use_powers`, reference the instance variables `name` and `power` - `name` being created via the `attr_reader` 
method in my class definition. These two methods will return different values when the corresponding instance variables
have different values, as is the case with this example.

The third instance method `exclaim`, does not reference any part of the object instance's state, and always outputs
the same value regardless of what its receiving object is. This results in the method returning the same value for both 
`Superhero` objects pointed to by the `batman` and `storm` local variables.

=end