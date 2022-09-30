class Puppy
  attr_accessor :name, :age, :breed  

  def initialize(name, age, breed)
    @name = name
    @age = age
    @breed = breed
  end

  def speak
    "#{@name} says woooof!"
  end


  def introduce
    puts "#{@name} is a #{@age} year old #{@breed}"
  end

end


puts "what is your dog's name?"
dog_name = gets.chomp

puts "Age?"
dog_age = gets.chomp

puts "Breed?"
dog_breed = gets.chomp

my_puppy = Puppy.new(dog_name, dog_age, dog_breed)
my_puppy.introduce 

puts "What would you like to change the age to?"
new_age = gets.chomp

my_puppy.age = new_age
puts "OK, #{my_puppy.name}'s age is now #{my_puppy.age}"


module Actions
  def speak
    puts "Hello"
  end

  def yell
    puts "HELLO!"
  end

  def whisper
    puts "hi"
  end
end


class Human
  include Actions
end

daughter = Human.new


module Careers
  class Engineer
  end

  class Teacher
  end

end

first_job = Careers::Teacher.new