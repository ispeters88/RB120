# Fix the Program - Mailable

# Correct the following program so it will work properly. 
# Assume that the Customer and Employee classes have complete implementations; 
# just make the smallest possible change to ensure that objects of both types have access to the print_address method.

require "pry-byebug"

module Mailable
  
  def print_address
    puts "#{name}"
    puts "#{address}"
    puts "#{city}, #{state} #{zipcode}"
  end
end

class Customer
  include Mailable
  attr_reader :name, :address, :city, :state, :zipcode
  
  def initialize(name, address, city, state, zip)
    @name = name
    @address = address
    @city = city
    @state = state
    @zip = zip
  end

end

class Employee
  include Mailable
  attr_reader :name, :address, :city, :state, :zipcode
end

betty = Customer.new('Betty','200 Kennedy Plaza', 'Providence', 'RI', '02860')
bob = Employee.new
betty.print_address
bob.print_address