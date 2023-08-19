require 'yaml'
MESSAGES = YAML.load_file('21_messages.yml')

module CardRenderable
  def display_card_left(cards)
    puts top(cards)
    puts suit_left(cards)
    puts center(cards)
    puts suit_right(cards)
    puts bottom(cards)
  end

  def display_card_right(cards)
    puts top(cards).rjust(80)
    puts suit_left(cards).rjust(80)
    puts center(cards).rjust(80)
    puts suit_right(cards).rjust(80)
    puts bottom(cards).rjust(80)
  end

  private

  def top(cards)
    arr = []
    cards.each do |_|
      arr << ("┌#{('─' * 4)}┐")
    end
    arr.join(' ')
  end

  def bottom(cards)
    arr = []
    cards.each do |_|
      arr << (("└#{('─' * 4)}┘"))
    end
    arr.join(' ')
  end

  def suit_left(cards)
    arr = []
    cards.each do |card|
      arr << ("│#{card.suit}#{(' ' * 3)}│")
    end
    arr.join(' ')
  end

  def center(cards)
    arr = []
    cards.each do |card|
      arr << if card.rank == '10'
               center_for_ten(card.rank)
             else
               ("│" " #{card.rank}  " "│")
             end
    end
    arr.join(' ')
  end

  def center_for_ten(rank)
    ("│" " #{rank} " "│")
  end

  def suit_right(cards)
    arr = []
    cards.each do |card|
      arr << ("│#{(' ' * 3)}#{card.suit}│")
    end
    arr.join(' ')
  end
end

module Displayable
  def display_flop
    puts "The dealer has:".rjust(80)
    dealer_cards = [dealer.cards.first, Card.new(" ", " ")]
    display_card_right(dealer_cards)

    human.display_hand
    human.display_current_hand_value
  end

  def display_busted
    loosing_player = human.busted? ? human.name : dealer.name
    winning_player = loosing_player == human.name ? dealer.name : human.name
    puts "Oof looks like #{loosing_player} BUSTED!".center(80)
    puts "#{winning_player} Wins!".center(80)
  end

  def orchestrate_winning_hand_display
    puts "The results are..."
    dealer.display_hand
    dealer.display_current_hand_value
    human.display_hand
    human.display_current_hand_value
    display_winner_of_hand
  end

  def display_winner_of_hand
    human_hand_value = human.total
    dealer_hand_value = dealer.total
    if human_hand_value == dealer_hand_value
      puts "Its a tie!".center(80)
    elsif human_hand_value > dealer_hand_value
      puts "#{human.name} Won!".center(80)
    elsif human_hand_value < dealer_hand_value
      puts "#{dealer.name} Won!".center(80)
    end
  end

  def display_rules
    rules = paragraph_from_str(MESSAGES['rules'], 55)
    rules.each { |str| puts str.center(80) }
  end

  def display_welcome
    system 'clear'
    MESSAGES['welcome'].each do |line|
      puts line.center(80)
    end
    puts ''
  end

  def shuffle_animation
    (1..40).each do |num|
      system 'clear'
      puts 'Shuffling...'.rjust(num * 2)
      sleep(0.075)
    end
    system 'clear'
  end

  def paragraph_from_str(text, width=40)
    arr = []
    text = text.split
    while text.size.positive?
      str = ''
      str << "#{text.shift} " while text.size.positive? &&
                                    (str.size + text.first.size + 1) <= width
      arr << str.rstrip
    end
    arr
  end
end

class Participant
  ACE_VALUES_BY_NUMBER = { 1 => [11, 1], 2 => [12, 2], 3 => [13, 3],
                           4 => [14, 4] }.freeze

  include CardRenderable
  attr_accessor :cards, :deck

  def initialize
    @cards = []
  end

  def dealt(card)
    cards.push(card)
  end

  def hand(player_cards = cards)
    player_cards.map(&:to_s).join(', ')
  end

  def busted?
    total > 21
  end

  def total
    aces, non_aces = cards.partition { |card| card.rank == 'A' }

    hand_value = sum_non_ace_cards(non_aces)
    hand_value += calculate_ace_value(hand_value, aces) unless aces.empty?

    hand_value
  end

  private

  def sum_non_ace_cards(array_of_cards)
    array_of_cards.reduce(0) do |acc, card|
      if card.rank.to_i.to_s == card.rank
        acc + card.rank.to_i
      elsif %w(J Q K).include?(card.rank)
        acc + 10
      end
    end
  end

  def calculate_ace_value(hand_value, ace_arr)
    possible_ace_values = ACE_VALUES_BY_NUMBER[ace_arr.size].dup

    ace_value = possible_ace_values.reject { |v| (v + hand_value) > 21 }

    return 1 if ace_value.empty? # if busted
    ace_value.max
  end
end

class Player < Participant
  attr_accessor :name

  def prompt_name
    answer = ''
    loop do
      puts 'What is your name?'
      answer = gets.chomp.strip.capitalize

      break if answer.size.positive?

      puts 'Please enter a name'
    end
    self.name = answer
  end

  def display_current_hand_value
    puts ''
    puts "Your hand value is #{total}."
    puts ''
  end

  def display_hand
    puts "#{name}'s hand is:"

    display_card_left(cards)
  end

  def prompt_hit_or_stay
    answer = nil
    loop do
      puts MESSAGES['hit_or_stay'].center(80)
      answer = gets.chomp.downcase
      break if %w(h s).include?(answer)
      puts "Sorry, must enter 'h' or 's'."
    end
    answer
  end

  def hit_player
    dealt(deck.card_from_deck)
    puts 'You have decided to hit!'
    puts ''
    display_hand
    display_current_hand_value
  end

  def turn
    puts 'Its your turn...'
    loop do
      break if busted?
      choice = prompt_hit_or_stay
      if choice == 's'
        puts 'You have decided to stay'
        break
      end
      hit_player
    end
  end
end

class Dealer < Participant
  attr_accessor :name, :cards

  def initialize
    @name = init_dealer_name
    super
  end

  def init_dealer_name
    %w(Moe Larry Curly).sample
  end

  def display_current_hand_value
    puts ''
    puts "#{name}'s hand value is #{total}".rjust(80)
  end

  def turn
    dealer_display("Its Dealer #{name}'s turn.")
    loop do
      sleep(2)
      break if busted?
      if total >= 17 && !busted?
        dealer_display("Dealer #{name} stays")
        break
      end
      hit_dealer
    end
  end

  def hit_dealer
    dealer_display("Dealer #{name} hits")
    dealt(deck.card_from_deck)
    display_hand
  end

  def display_hand
    puts 'The dealer has:'.rjust(80)
    display_card_right(cards)
  end

  def dealer_display(text)
    puts text.rjust(80)
  end
end

class Deck
  SUITS = %w(♠ ♥ ♣ ♦).freeze
  RANK = %w(A 2 3 4 5 6 7 8 9 10 J Q K).freeze

  attr_accessor :cards

  def initialize
    @cards = init_new_deck
  end

  def card_from_deck
    cards.delete(cards.sample)
  end

  def init_new_deck
    deck = []
    SUITS.each do |suit|
      RANK.each do |rank|
        deck << Card.new(suit, rank)
      end
    end
    @cards = deck
  end
end

class Card
  attr_reader :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end

  def to_s
    "The #{rank} of #{suit}"
  end
end

class Game
  include Displayable
  include CardRenderable

  attr_accessor :human, :dealer, :deck

  def initialize
    @human = Player.new
    @dealer = Dealer.new
  end

  def start
    game_intro
    loop do
      reset
      deal_cards
      display_flop
      player_and_dealer_turn
      result_of_round
      prompt_play_again
    end
  end

  def player_and_dealer_turn
    human.turn
    return if human.busted?

    dealer.turn
  end

  def game_intro
    display_welcome
    human.prompt_name
    display_rules if rules?
    prompt_begin
  end

  def prompt_begin
    answer = ''
    loop do
      puts ''
      puts "Would you like to begin? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Invalid inputs please use 'y' or 'n'."
    end
    return unless answer == 'n'
    exit_game
  end

  def exit_game
    puts "Alright well I guess it's goodbye."
    exit
  end

  def reset
    new_deck
    human.cards = []
    dealer.cards = []
    shuffle_animation
  end

  def new_deck
    @deck = Deck.new
    human.deck = @deck
    dealer.deck = @deck
  end

  def rules?
    answer = ''
    loop do
      puts "Hello #{human.name} do you need to see the rules? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Invalid inputs please use 'y' or 'n'."
    end
    answer == 'y'
  end

  def prompt_play_again
    answer = ""
    loop do
      puts "Would you like to play again?(y/n)".center(80)
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Invalid inputs please use 'y' or 'n'."
    end
    return true if answer == 'y'
    exit_game
  end

  def result_of_round
    if human.busted? || dealer.busted?
      display_busted
      return
    end
    orchestrate_winning_hand_display
  end

  def deal_cards
    2.times do |_|
      human.dealt(deck.card_from_deck)
      dealer.dealt(deck.card_from_deck)
    end
  end
end

game = Game.new
game.start
