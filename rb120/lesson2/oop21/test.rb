class Deck
  @@number = 0
  def initialize
    @@number += 1
  end 
end


class Game
  attr_accessor :deck

  def initialize
    @person = Person.new
  end

  def make_new_deck
    @deck = Deck.new
    
  end
end

class Person
  def initialize
    @name = 'Bruce'
  end
end