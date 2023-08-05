

class Pet 
  def jump
    'jumping!'
  end

  def run
    'running!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    'Meow!'
  end
end

class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

karl = Bulldog.new
puts karl.speak           # => "bark!"
puts karl.swim            # => "can't swim!"

pete = Pet.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

