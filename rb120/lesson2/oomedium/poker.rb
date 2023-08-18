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


# Include Card and Deck classes from the last two exercises.
=begin

a poker hand takes an array of cards

print outputs the hand
hand.evalute outputs the hand value

evaluate is our orchestation method
  predicates are our compare methods
=end
end

class PokerHand
  attr_reader :hand
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
  
  def all_hand_ranks_in_array?(ranks)
    hand_ranks = hand.map { |card| card.rank }
    ranks.all? { |rank| hand.include?(ranks)}
  end

  def all_ranks_in_hand?(ranks)
    hand.all? { |card| ranks.include?(card.rank)}
  end



  def royal_flush?
    ranks = [10, 'Jack', 'Queen', 'King', 'Ace']
    
    all_hand_ranks_in_array?(ranks) && 
    all_ranks_in_hand?(ranks) &&
    same_suit?
  end

  def straight_flush?
  end

  def four_of_a_kind?
  end

  def full_house?
  end

  def flush?
  end

  def straight?
  end

  def three_of_a_kind?
  end

  def two_pair?
  end

  def pair?
  end
end

