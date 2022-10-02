# Exercise 3
# Fix the Program - Books (Part 1)
# Complete this program so that it produces the expected output:

class Book
  attr_reader :author, :title
  
  def initialize(author, title)
    @author = author
    @title = title
  end

  def to_s
    %("#{title}", by #{author})
  end
end

book = Book.new("Neil Stephenson", "Snow Crash")
puts %(The author of "#{book.title}" is #{book.author}.)
puts %(book = #{book}.)

# Expected output:

# The author of "Snow Crash" is Neil Stephenson.
# book = "Snow Crash", by Neil Stephenson.


# Further Exploration
# What are the differences between attr_reader, attr_writer, and attr_accessor? 
# Why did we use attr_reader instead of one of the other two? Would it be okay to use one of the others? Why or why not?
# 

# attr_reader builds a 'getter' method for the listed instance variable(s), which provides view access to the variable(s),
# outside the class definition
# attr_writer builds a 'setter' method, which similarly provides edit access
# attr_accessor builds both a getter and a setter method

# We used attr_reader because it provided the minimal amount of access necessary to allow the program to produce the 
# requested result. We could have used attr_accessor and that would have been effective, but would unnecessarily
# provide write/edit access to our @title and @author instance variables. attr_writer would not have been sufficient, as 
# we would not be able to view the values of the instance variables.

# Instead of attr_reader, suppose you had added the following methods to this class:

def title
  @title
end

def author
  @author
end

# Would this change the behavior of the class in any way? 
# If so, how? If not, why not? Can you think of any advantages of this code?

# This would have the same effect; the attr_reader method implements these getter methods in exactly this way