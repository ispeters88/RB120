# Exercise 7
# Pet Shelter

# Consider the following code:

class Pet
  attr_reader :type, :name

  def initialize(type, name)
    @type = type
    @name = name
  end

  def to_s
    "a #{type} named #{name}"
  end
end

class Owner
  attr_reader :name, :pets

  def initialize(name)
    @name = name
    @pets = Array.new
  end

  def get_pet(pet)
    @pets << pet
  end

  def number_of_pets
    pets.size
  end

  def list_pets
    puts pets
  end

end

class Shelter
  attr_reader :adoptions, :unadopted

  def initialize
    @adoptions = Hash.new([])
    @unadopted = Owner.new("The Animal shelter")
  end

  def adopt(owner, pet)
    owner.get_pet(pet)
    @adoptions[owner.name] = owner
  end

  def print_adoptions
    @adoptions.each do |name, owner|
      puts "#{name} has adopted the following pets:"
      owner.list_pets
    end
  end

  def print_unadopted
    puts "The Animal shelter has the following unadopted pets: "
    @unadopted.list_pets
  end
end


butterscotch = Pet.new('cat', 'Butterscotch')
pudding      = Pet.new('cat', 'Pudding')
darwin       = Pet.new('bearded dragon', 'Darwin')
kennedy      = Pet.new('dog', 'Kennedy')
sweetie      = Pet.new('parakeet', 'Sweetie Pie')
molly        = Pet.new('dog', 'Molly')
chester      = Pet.new('fish', 'Chester')

phanson = Owner.new('P Hanson')
bholmes = Owner.new('B Holmes')

shelter = Shelter.new
shelter.adopt(phanson, butterscotch)
shelter.adopt(phanson, pudding)
shelter.adopt(phanson, darwin)
shelter.adopt(bholmes, kennedy)
shelter.adopt(bholmes, sweetie)
shelter.adopt(bholmes, molly)
shelter.adopt(bholmes, chester)

shelter.print_adoptions
puts "#{phanson.name} has #{phanson.number_of_pets} adopted pets."
puts "#{bholmes.name} has #{bholmes.number_of_pets} adopted pets."



# Write the classes and methods that will be necessary to make this code run, and print the following output:

# P Hanson has adopted the following pets:
# a cat named Butterscotch
# a cat named Pudding
# a bearded dragon named Darwin
# 
# B Holmes has adopted the following pets:
# a dog named Molly
# a parakeet named Sweetie Pie
# a dog named Kennedy
# a fish named Chester
# 
# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.


# Further Exploration
# Add your own name and pets to this project.
# 
# Suppose the shelter has a number of not-yet-adopted pets, and wants to manage them through this same system. 
# Thus, you should be able to add the following output to the example output shown above:
# 

asta = Pet.new('dog', 'Asta')
laddie = Pet.new('dog', 'Laddie')
fluffy = Pet.new('cat', 'Fluffy')
kat = Pet.new('cat', 'Kat')
ben = Pet.new('cat', 'Ben')
chatterbox = Pet.new('parakeet', 'Chatterbox')
bluebell = Pet.new('parakeet', 'Bluebell')


shelter.adopt(shelter.unadopted, asta)
shelter.adopt(shelter.unadopted, laddie)
shelter.adopt(shelter.unadopted, fluffy)
shelter.adopt(shelter.unadopted, kat)
shelter.adopt(shelter.unadopted, ben)
shelter.adopt(shelter.unadopted, chatterbox)
shelter.adopt(shelter.unadopted, bluebell)
shelter.print_unadopted
puts "The Animal shelter has #{shelter.unadopted.number_of_pets} unadopted pets"


# The Animal Shelter has the following unadopted pets:
# a dog named Asta
# a dog named Laddie
# a cat named Fluffy
# a cat named Kat
# a cat named Ben
# a parakeet named Chatterbox
# a parakeet named Bluebell
#    ...
# 
# P Hanson has 3 adopted pets.
# B Holmes has 4 adopted pets.
# The Animal shelter has 7 unadopted pets.
# Can you make these updates to your solution? Did you need to change your class system at all? 
# Were you able to make all of your changes without modifying the existing interface?


