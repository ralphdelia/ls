class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name
    first_name + " " + last_name
  end

  def name=(n)
    parse_full_name(n)
  end

  def to_s
    self.name 
  end

  private

  def parse_full_name(n)
    parts = n.split 
    @first_name = parts.first 
    @last_name = parts.size > 1 ? parts.last : ''
  end
end



bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"