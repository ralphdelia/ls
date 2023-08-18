class Card
  RANK_ORDER = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King', 'Ace'].freeze

  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def position_of(rank)
    RANK_ORDER.index(rank)
  end

  def <=>(other)
    if position_of(rank) > position_of(other.rank)
      1
    elsif position_of(rank) < position_of(other.rank)
      -1
    else
      0
    end
  end

  def ==(other)
    rank == other.rank && suit == other.suit
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze
  
  attr_accessor :cards
  
  def initialize
    @cards = new_deck
  end
  
  def draw
    new_deck if @cards.empty?
    cards.pop
  end

  private 
  
  def new_deck
    arr = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        arr << Card.new(rank, suit)
      end
    end
    self.cards = arr.shuffle 
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
puts drawn.count { |card| card.rank == 5 } == 4
puts drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
puts drawn != drawn2 # Almost always.