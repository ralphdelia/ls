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

  def equal_rank?(other)
    rank == other
  end

  def ==(other)
    rank == other.rank && suit == other.suit
  end

  def to_s
    "#{rank} of #{suit}"
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


class PokerHand
  attr_accessor :hand
  def initialize(hand)
    @hand = hand
  end

  def print
    puts hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def same_suit?
    hand.all? do |card|
      hand.first.suit == card.suit
    end
  end
  
  def all_ranks_in_array?(ranks)
    hand_ranks = hand.map { |card| card.rank }

    ranks.all? { |rank| hand_ranks.include?(rank)}
  end

  def of_a_kind?(num)
    hand_ranks = hand.map { |card| card.rank }
    #unique ranks  counting the unique ranks in the hand and seeing if they equal our num
    hand_ranks.uniq.any? do |rank| 
      hand.count { |card| card.equal_rank?(rank)} == num
    end
  end



  def royal_flush?
    ranks = [10, 'Jack', 'Queen', 'King', 'Ace']
    
    
    all_ranks_in_array?(ranks) && same_suit?
  end

  def straight_flush?
    ranks = []  
    (0..Card::RANK_ORDER.size - 5).each do |index|
      ranks << Card::RANK_ORDER[index..index + 4]
    end

    same_suit? && ranks.any?{ |rank| all_ranks_in_array?(rank) }
  end

  def four_of_a_kind?
    of_a_kind?(4)
  end

  def full_house?
    hand_ranks = hand.map { |card| card.rank }
    if hand_ranks.uniq.size == 2
      [2, 3].all? do |num| 
        of_a_kind?(num)
      end
    end
  end

  def flush?
    same_suit?
  end

  def straight?
    sets_of_five_ranks = []  
    (0..Card::RANK_ORDER.size - 5).each do |index|
      sets_of_five_ranks << Card::RANK_ORDER[index..index + 4]
    end

    sets_of_five_ranks.any? { |ranks| all_ranks_in_array?(ranks) }
  end

  def three_of_a_kind?
    of_a_kind?(3)
  end
#we have their ranks 
#we want to eliminate the element that only occurs once
#chec
  def two_pair?
    hand_ranks = hand.map { |card| card.rank }

    hand_ranks = hand_ranks.select do |rank|
      hand_ranks.count(rank) > 1
    end

    hand_ranks.uniq.all? do |rank| 
      hand.count { |card| card.equal_rank?(rank)} == 2
    end
  end

  def pair?
    of_a_kind?(2)
  end
end

#hand = PokerHand.new(Deck.new)
#hand.print
#puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'
