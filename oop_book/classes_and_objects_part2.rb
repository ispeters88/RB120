class Puppy
  attr_accessor :name, :cuteness

  @@puppy_total = 0
  @@cuteness_avg = 0

  def initialize(name, cuteness)
    @@cuteness_avg = (@@cuteness_avg * @@puppy_total + cuteness) / (@@puppy_total + 1)
    puts "the average cuteness is now #{@@cuteness_avg}"
    @@puppy_total += 1
    @name = name
    @cuteness = cuteness
  end

  def self.get_puppy_total
    @@puppy_total
  end

  def what_is_self
    self
  end

  def to_s
    "The newest puppy is named #{name}; its cuteness quotient is #{cuteness}"
  end

end


class MyCar
  attr_accessor :color
  attr_reader :year

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model

    @speed = 0
  end

  def speed_up(number)
    @speed += number
    puts "You press the gas and accelerate by #{number} miles per hour"
  end

  def brake(number)
    @speed -= number
    puts "You press the brake and slow down by #{number} miles per hour"
  end

  def current_speed
    puts "You are now going #{@speed} miles per hour"
  end

  def turn_off
    @speed = 0
    puts "Don't forget to put the car in park!"
  end

  def spray_paint(new_color)
    self.color = new_color
    puts "Rad! Your car is now #{my_car.color}"
  end

  def self.gas_mileage(gal, miles)
    puts "This car gets #{miles / gal} miles to the gallon"
  end

  def to_s
    "This car is a #{color} #{@model} from the year #{year}"
  end

end
=begin
MyCar.gas_mileage(13, 370)

my_car = MyCar.new(2015, "black", "Subaru Forester")

puts my_car
=end

class Person
  attr_accessor :name
  def initialize(name)
    @name = name
  end
end

bob = Person.new("Steve")
bob.name = "Bob"

class Animal
  def initialize
  end
end

class Bear < Animal
  def initialize(color)
    super()
    @color = color
  end
end

bear = Bear.new("black")        # => #<Bear:0x007fb40b1e6718 @color="black">