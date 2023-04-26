# Alan created the following code to keep track of items for a shopping cart application he's writing:

class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

# Alyssa looked at the code and spotted a mistake. "This will fail when update_quantity is called", she says.

# Can you spot the mistake and how to address it?

# > We do not have any way to change the value of the quantity IVar. 
# We need to add an attr_accessor to provide write access to the quantity IVar, and
# use the `self` prefix on the `update_quantity` method as defined below - this is so Ruby knows that we are 
# working with an IVar as oppoed to a local variable

class InvoiceEntry
  attr_reader :product_name
  attr_accessor :quantity

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    self.quantity = updated_count if updated_count >= 0
  end
end

invoice = InvoiceEntry.new("bowling pins", 24)
invoice.update_quantity(10)
p invoice


# LS solution reminds that we can simply use the `@` prefix:

class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    @quantity = updated_count if updated_count >= 0
  end
end

invoice = InvoiceEntry.new("bowling pins", 24)
invoice.update_quantity(10)
p invoice