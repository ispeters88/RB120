# Ben asked Alyssa to code review the following code:

class BankAccount
  attr_reader :balance
  attr_writer :balance

  def initialize(starting_balance)
    @balance = starting_balance
  end

  def positive_balance?
    balance >= 0
  end

  def increase_balance
    @balance += 100
  end
end

checking_account = BankAccount.new(1000)
puts checking_account.positive_balance?
5.times { checking_account.increase_balance }
p checking_account

# 
# Alyssa glanced over the code quickly and said - 
# "It looks fine, except that you forgot to put the 
# @ before balance when you refer to the balance instance 
# variable in the body of the positive_balance? method."
# 
# "Not so fast", Ben replied. "What I'm doing here is valid - I'm not missing an @!"
# 
# Who is right, Ben or Alyssa, and why?

# > Ben is correct. He has defined an attr_reader method for the balance IVar, which gives read access to the variable.
# Because we are just reading the value of the IVar, we do not need to disambiguate between a local variable and 
# an IVar with the `@` symbol -- Ruby does this in the background by way of the attr_reader method.

# If we tried to do this with a setter method, we would run into trouble because Ruby assumes a variable defined without
# `self` is a local variable, rather than an instance variable.