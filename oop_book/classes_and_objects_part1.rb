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
end


my_car = MyCar.new(2015, "black", "Subaru Forester")

puts "your car is #{my_car.color}"

puts "You have won a free paint job! What color would you like to change your car to?"
color_choice = gets.chomp

my_car.spray_paint(color_choice)