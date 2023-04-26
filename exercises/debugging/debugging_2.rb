# Animal Kingdom
# 
# The code below raises an exception. Examine the error message and alter the code so that it runs without error.

class Animal
  def initialize(diet, superpower)
    @diet = diet
    @superpower = superpower
  end

  def move
    puts "I'm moving!"
  end

  def superpower
    puts "I can #{@superpower}!"
  end
end

class Fish < Animal
  def move
    puts "I'm swimming!"
  end
end

class Bird < Animal
end

class FlightlessBird < Bird
  #def initialize(diet, superpower)
  #  super
  #end

  def move
    puts "I'm running!"
  end
end

class SongBird < Bird
  def initialize(diet, superpower, song)
    # super
    super(diet, superpower)
    @song = song
  end

  def move
    puts "I'm flying!"
  end
end

# Examples

unicornfish = Fish.new(:herbivore, 'breathe underwater')
penguin = FlightlessBird.new(:carnivore, 'drink sea water')
robin = SongBird.new(:omnivore, 'sing', 'chirp chirrr chirp chirp chirrrr')
p penguin


# When super is called with no arguments, all the passed in arguments to the class constructor are passed along to the
# first superclass method found/used. In this case, the superclass method (from `Bird`) expects 2 arguments, but we
# pass it 3. 

# To correct this, we should call `super` with just the arguments we want to send along - diet and superpower

# Further Exploration
# Is the FlightlessBird#initialize method necessary? Why or why not?

# > It is not necessary; without it defined, the initialize method from `Bird` will be used.