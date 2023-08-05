class Shelter
  attr_accessor :adoption_recipts
  
  def initialize
    @adoption_recipts = {}
  end

  def adopt(owner, pet)
    owner.pets << pet
    pet_info = [pet.type, pet.name]
    file_recipts(owner.name, pet_info)
  end

  def print_adoptions
    adoption_recipts.each do |name, pets|
      puts "#{name} has adopted the following pets:"
      
      pets.each do |pet|
        puts "a #{pet.first} named #{pet.last}"
      end
    end
  end
  
  private 
  
  def file_recipts(owner_name, pet_info_array)
    if adoption_recipts.key?(owner_name)
      adoption_recipts[owner_name] << pet_info_array
    elsif !adoption_recipts.key?(owner_name)
      adoption_recipts[owner_name] = [pet_info_array]
    end
  end
end

class Pet 
  attr_reader :type, :name
  
  def initialize(type, name)
    @type = type
    @name = name
  end
end

class Owner 
  attr_reader :pets, :name

  def initialize(name)
    @name = name
    @pets = []
  end

  def number_of_pets
    pets.size
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