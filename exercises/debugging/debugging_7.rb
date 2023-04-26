# Bank Balance

# We created a simple BankAccount class with overdraft protection,
# that does not allow a withdrawal greater than the amount of the current balance.
# We wrote some example code to test our program. 
# However, we are surprised by what we see when we test its behavior. 
# Why are we seeing this unexpected output? Make changes to the code so that we see the appropriate behavior.


class BankAccount
  attr_reader :balance

  def initialize(account_number, client)
    @account_number = account_number
    @client = client
    @balance = 0
  end

  def deposit(amount)
    if amount > 0
      self.balance += amount
      "$#{amount} deposited. Total balance is $#{balance}."
    else
      "Invalid. Enter a positive amount."
    end
  end

  def withdraw(amount)
    # old
    # if amount > 0
    #   success = (self.balance -= amount)
    # else
    #   success = false
    # end
# 
    # if success
    #   "$#{amount} withdrawn. Total balance is $#{balance}."
    # else
    #   "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    # end

    # new
    if self.balance - amount >= 0
      self.balance -= amount
      "#{amount} withdrawn. Total balance is $#{balance}."
    else
      "Invalid. Enter positive amount less than or equal to current balance ($#{balance})."
    end
  end

  def balance=(new_balance)
    if valid_transaction?(new_balance)
      @balance = new_balance
      true
    else
      false
    end
  end

  def valid_transaction?(new_balance)
    new_balance >= 0
  end
end

# Example

account = BankAccount.new('5538898', 'Genevieve')

                          # Expected output:
p account.balance         # => 0
p account.deposit(50)     # => $50 deposited. Total balance is $50.
p account.balance         # => 50
p account.withdraw(80)    # => Invalid. Enter positive amount less than or equal to current balance ($50).
                          # Actual output: $80 withdrawn. Total balance is $50.
p account.balance         # => 50



# Further Exploration
# What will the return value of a setter method be if you mutate its argument in the method body?


class Setter
  attr_reader :name, :type

  def initialize(name, type)
    # both attributes are String objects
    @name = name
    @type = type
  end

  def test_mutation
    if name.size > 4
      success = name.chop!
    else
      success = false
    end

    p success


    # if success
    #   p "This was successful"
    #   p name.object_id
    # else
    #   p "This was unsuccessful"
    #   p name.object_id
    # end
  end
end

my_setter = Setter.new("Isaac", "testing")

p my_setter.test_mutation

# > If we mutate the argument within the setter method, we will still return that object, but it will be mutated.