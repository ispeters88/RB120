# Exercise 6
# Fix the Program - Flight Data

# Consider the following class definition:

class Flight
  attr_accessor :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end

# There is nothing technically incorrect about this class, but the definition may lead to problems in the future. How can this class be fixed to be resistant to future problems?

# We are providing edit/write access to change the value of the `database_handle` instance variable, 
# which by the name and the refernece to a separate class called Database,
# seems like a fairly important attribute. It would be safer to provide read only access, 
# and then if necessary to provide edit access, give it in the form of a separate setter method that is
# protected in some way.

# for ex.

class Flight
  attr_reader :database_handle

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end

  def db_handle=(handle)
    @database_handle = maybe_update_handle(handle)
  end
end


## Based on hint from LS-
# what if a database is not used in the future? We don't know for sure that the `Database` object keeps track of our `flight_number` instance variable, but it seems likely
# If so, and we lose the database, we have no way to access the @flight_number IV

# second perspective:

class Flight
  attr_accessor :database_handle
  attr_reader :flight_number

  def initialize(flight_number)
    @database_handle = Database.init
    @flight_number = flight_number
  end
end