class Person
  
  def name=(n)
    n = n.split(' ')
    @first_name = n.first
    @last_name = n.last 
  end

  def name
    first_name + " " + last_name
  end
  
  private 
  
  attr_reader :first_name, :last_name
end

person1 = Person.new
person1.name = 'John Doe'
puts person1.name