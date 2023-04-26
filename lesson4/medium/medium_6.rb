# If we have these two methods in the Computer class:

class Computer
  attr_accessor :template

  def create_template
    @template = "template 14231"
  end

  def show_template
    template
  end
end

computer1 = Computer.new
computer1.create_template
p computer1.show_template

# and

class Computer
  attr_accessor :template

  def create_template
    self.template = "template 14231"
  end

  def show_template
    self.template
  end
end

computer2 = Computer.new
computer2.create_template
p computer2.show_template

# What is the difference in the way the code works?

# > There is no difference in the functionality of the two class definitions. The `#show_templates` method
# in the second definition of `Computer` contains a superflous `self` prefix