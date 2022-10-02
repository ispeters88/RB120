# Exercise 10
# Refactoring Vehicles

#  Consider the following classes:

class Car
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def wheels
    4
  end

  def to_s
    "#{make} #{model}"
  end
end

class Motorcycle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def wheels
    2
  end

  def to_s
    "#{make} #{model}"
  end
end

class Truck
  attr_reader :make, :model, :payload

  def initialize(make, model, payload)
    @make = make
    @model = model
    @payload = payload
  end

  def wheels
    6
  end

  def to_s
    "#{make} #{model}"
  end
end

# Refactor these classes so they all use a common superclass, and inherit behavior as needed.

class Vehicle
  attr_reader :make, :model

  def initialize(make, model)
    @make = make
    @model = model
  end

  def to_s
    "#{make} #{model}"
  end

end

class Car < Vehicle

  def wheels
    4
  end
end

class Motorcycle < Vehicle

  def wheels
    2
  end
end

class Truck < Vehicle
  attr_reader :payload

  def initialize(make, model, payload)
    super(make, model)
    @payload = payload
  end

  def wheels
    6
  end
end

#Further Exploration
# Would it make sense to define a wheels method in Vehicle even though all of 
# the remaining classes would be overriding it? Why or why not? If you think it does make sense, 
# what method body would you write?

# It would make sense assuming we can expect that the majority of vehicle objects have a certain number of wheels. 
# We could assume that 4 wheels is the baseline
# This would be more applicable to a more detailed sub class hierarchy, where 'car' is broken out into more subclasses.
# it is also strange that 6 wheels are listed for trucks; most consumer trucks have 4 wheels
