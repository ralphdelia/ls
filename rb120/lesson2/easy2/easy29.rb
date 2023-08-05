module Walkable
  def walk
    puts "#{self} #{gait} forward"
  end
end

module Stringable
  def to_s
    name
  end
end


class Person
  include Walkable, Stringable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    'strolls'
  end
end

class Cat
  include Walkable, Stringable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    'saunters'
  end
end

class Cheetah
  include Walkable, Stringable
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    'runs'
  end
end

class Noble
  attr_reader :title, :name

  include Walkable
  
  def initialize(n, t)
    @name = n
    @title = t
  end

  def to_s 
    "#{title} #{name}"
  end

  private 

  def gait
    'struts'
  end
end


mike = Person.new('Mike')
mike.walk
# => "Mike strolls forward"

kitty = Cat.new('Kitty')
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new('Flash')
flash.walk
# => "Flash runs forward"


byron = Noble.new("Byron", "Lord")
byron.walk
# => "Lord Byron struts forward"