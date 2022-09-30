module Towable

  def can_tow?(weight)
    weight < 3500
  end

end

class Vehicle
  attr_accessor :color
  attr_reader :year

  @@vehicle_count = 0

  def initialize(year, color="red", model="Forester")
    @year = year
    @color = color
    @model = model
    @speed = 0

    @@vehicle_count += 1
  end

  def self.total_vehicles
    puts "So far, #{@@vehicle_count} vehicles have been created"
  end

  def year=(year)
    @year = year * 2
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
    "This vehicle is a #{color} #{@model} from the year #{year}. It is #{self.vehicle_age}"
  end

  def age
    "Your vehicle is #{vehicle_age} years old"
  end

  private
  
  def vehicle_age
    Time.new.year - year.to_i
  end


end

class MyTruck < Vehicle
  include Towable

  BODY = "Truck"
  
end

class MyCar < Vehicle
  BODY = "SUV"
end


forester = MyCar.new(2015,)
puts forester

p forester.age

forester.year = 2016
p forester.year

class Student

  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(other)
    @grade > other.get_grade
  end

  protected

  def get_grade
    @grade
  end

  private
  def hi
    puts "Hi, my name is #{name}!"
  end

end

joe = Student.new("Joe",95)
bob = Student.new("Bob",85)

puts "Well done!" if joe.better_grade_than?(bob)

class MeMyselfAndI
  #puts self

  def self.me
    puts self
  end

  def myself
    puts self
  end
end

i = MeMyselfAndI.new
#MeMyselfAndI.me
i.myself