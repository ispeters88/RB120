# Ex1

=begin
class Person
  attr_accessor :name
end

person1 = Person.new
name = 'Jessica'
puts name


# Ex2

class Person
  attr_accessor :name
  attr_writer :phone_number
end

person1 = Person.new
person1.name = 'Jessica'
person1.phone_number = '0123456789'
puts person1.name



# Ex3
#Modify the following code so that the value of @phone_number can still be read as on line 10, 
#but cannot be changed as on line 12.



class Person
  attr_reader :phone_number

  def initialize(number)
    @phone_number = number
  end
end

person1 = Person.new(1234567899)
puts person1.phone_number

person1.phone_number = 9987654321
puts person1.phone_number



# Ex4

# Using the following code, add the appropriate accessor methods. 
# Keep in mind that the last_name getter shouldn't be visible outside the class, 
# while the first_name getter should be visible outside the class.

class Person
  attr_accessor :first_name
  attr_writer :last_name

  def first_equals_last?
    first_name == last_name
  end

  private

  attr_reader :last_name
end

person1 = Person.new
person1.first_name = 'Dave'
person1.last_name = 'Smith'
puts person1.first_equals_last?
puts person1.first_name
puts person1.last_name



# Ex5

# Using the following code, add the appropriate accessor methods. 
# Keep in mind that @age should only be visible to instances of Person.

class Person
  attr_writer :age

  def older_than?(other)
    age > other.age
  end

  protected

  attr_reader :age
end

person1 = Person.new
person1.age = 17

person2 = Person.new
person2.age = 26

puts person1.older_than?(person2)



# Ex6
# Using the following code, add the appropriate accessor methods so that @name is capitalized upon assignment.

class Person
  attr_reader :name

  def name=(name)
    @name = name.capitalize
  end
end

person1 = Person.new
person1.name = 'eLiZaBeTh'
puts person1.name


# Ex7
# Using the following code, add the appropriate accessor methods so that @name is returned with the added prefix 'Mr.'.

class Person
  attr_writer :name


  def name
    "Mr. #{@name}"
  end
end

person1 = Person.new
person1.name = 'James'
puts person1.name


# Ex8

# The following code is flawed. 
# It currently allows @name to be modified from outside the method via a destructive method call. 
# Fix the code so that it returns a copy of @name instead of a reference to it.

class Person
  def initialize(name)
    @name = name
  end

  def name
    @name.clone
  end
end

person1 = Person.new('James')
person1.name.reverse!
puts person1.name



# Ex9
# Using the following code, multiply @age by 2 upon assignment, 
# then multiply @age by 2 again when @age is returned by the getter method.

class Person
  def age=(age)
    @age = age * 2
  end
  
  def age
    @age * 2
  end
end

person1 = Person.new
person1.age = 20
puts person1.age

=end      

# Ex10
# Modify the following code to accept a string containing a first and last name. 
# The name should be split into two instance variables in the setter method, 
# then joined in the getter method to form a full name.

class Person
  def name=(full_name)
    names = full_name.split
    @first_name = names.first
    @last_name = names.last
  end

  def name
    [@first_name, @last_name].join(' ')
  end
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name