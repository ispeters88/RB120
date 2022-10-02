# Exercise 4
# Fix the Program - Books (Part 2)

# Complete this program so that it produces the expected output:

class Book
  attr_accessor :author, :title

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new
book.author = "Neil Stephenson"
book.title = "Snow Crash"
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

# Expected output:

# The author of "Snow Crash" is Neil Stephenson.
# book = "Snow Crash", by Neil Stephenson.

# Further Exploration

# What do you think of this way of creating and initializing Book objects? (The two steps are separate.)
# Would it be better to create and initialize at the same time like in the previous exercise? What potential problems, if any, are introduced by separating the steps?

# The two approaches
#   > initializing at object instanation
# vs
#   > instantiating object with no initial values for instance variables, then setting them after the fact
# both have different, useful purposes. There are circumstances where we want to control the initial state/attribute values for an object; in this case, initializing instance variables
# at the time of object instantiation is valuable. There are also times we want to provide full user control to set attributes. In this case, the approach used in this exercise 
# is more appropriate.

# Potential problems from separating steps of object instantiation and instance variable initialization
#   > bad user input (instance variables are initialized to incorrect or unexpected values)
#   > no user input (one or more instance variables never get initialized)
#   > unexpected changes in object state due to providing access to edit instance variables