require 'yaml'
MESSAGES = YAML.load_file('21_messages.yml')

class Participant
  ACE_VALUES_BY_NUMBER = { 1 => [11, 1], 2 => [12, 2], 3 => [13, 3],
                           4 => [14, 4] }.freeze

  attr_accessor :cards

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

  def sum_non_ace_cards(array_of_cards)
    array_of_cards.reduce(0) do |acc, card|
      if card.rank.to_i.to_s == card.rank
        acc + card.rank.to_i
      elsif %w(Jack Queen King).include?(card.rank)
        acc + 10
      end
    end
  end

  def calculate_ace_value(hand_value, ace_arr)
    possible_ace_values = ACE_VALUES_BY_NUMBER[ace_arr.size].dup

    ace_value = possible_ace_values.reject { |v| (v + hand_value) > 21 }

    return 22 if ace_value.empty? # if busted
    ace_value.max
  end

  def total
    aces, non_aces = cards.partition { |card| card.rank == 'Ace' }

    hand_value = sum_non_ace_cards(non_aces)
    hand_value += calculate_ace_value(hand_value, aces) unless aces.empty?

    hand_value
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
end

class Deck
  SUITS = %w(Spades Clubs Hearts Diamonds).freeze
  RANK = %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King).freeze

  attr_accessor :cards

  def initialize
    @cards = init_new_deck
  end

  def card_from_deck
    cards.delete(cards.sample)
  end

  def card_in_deck?(card)
    cards.include?(card)
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

module Displayable
  def display_flop
    dealer_display('The dealer has:')
    dealer_display("--#{dealer.cards.first}")
    dealer_display("--One card face down")
    human_display('Your cards are:')
    display_human_hand
  end

  def display_players_current_hand_value
    puts ''
    puts "Your hand value is #{human.total}."
  end

  def display_human_hand
    human.cards.each do |card|
      human_display("--#{card}")
    end
  end

  def display_busted
    loosing_player = human.busted? ? human.name : dealer.name
    winning_player = loosing_player == human.name ? dealer.name : human.name
    puts "Oof looks like #{loosing_player} BUSTED!".center(80)
    puts "#{winning_player} Wins!".center(80)
  end

  def display_dealer_hand
    dealer_display('The dealer has:')
    dealer.cards.each do |card|
      dealer_display("--#{card}")
    end
  end

  def human_display(text)
    text = paragraph_from_str(text)
    text.each { |str| puts str }
  end

  def dealer_display(text)
    if text.size > 40
      text = paragraph_from_str(text)
      text.each do |string|
        offset = 40 - string.size
        puts string.rjust(80 - offset)
      end
    else
      offset = 40 - text.size
      puts text.rjust(80 - offset)
    end
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
end

class Game
  include Displayable

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
      display_players_current_hand_value

      player_turn
      if human.busted?
        display_busted
        next if play_again?
      end

      dealers_turn
      if dealer.busted?
        display_busted
        next if play_again?
      end
      display_result_of_hand
      break unless play_again?
    end
  end

  def game_intro
    display_welcome
    human.prompt_name
    display_rules if rules?
    begin?
  end

  def begin?
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

  def shuffle_animation
    (1..40).each do |num|
      system 'clear'
      puts 'Shuffling...'.rjust(num * 2)
      sleep(0.1)
    end
    system 'clear'
  end

  def new_deck
    @deck = Deck.new
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

  def play_again?
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

  def display_result_of_hand
    puts "The results are..."
    display_dealer_hand
    display_dealer_current_hand_value

    puts "#{human.name}'s hand is:"
    display_human_hand
    display_players_current_hand_value

    display_winner_of_hand
  end

  def display_dealer_current_hand_value
    puts ''
    dealer_display("#{dealer.name}'s hand value is #{dealer.total}")
  end

  def display_winner_of_hand
    human_hand_value = human.total
    dealer_hand_value = dealer.total
    if human_hand_value == dealer_hand_value
      puts "Its a tie!"
    elsif human_hand_value > dealer_hand_value
      puts "#{human.name} Won!".center(80)
    elsif human_hand_value < dealer_hand_value
      puts "#{dealer.name} Won!".center(80)
    end
  end

  def deal_cards
    2.times do |_|
      human.dealt(deck.card_from_deck)
      dealer.dealt(deck.card_from_deck)
    end
  end

  def dealers_turn
    dealer_display("Its Dealer #{dealer.name}'s turn.")
    loop do
      sleep(2)
      if dealer.total >= 17 && !dealer.busted?
        dealer_display("Dealer #{dealer.name} stays")
        break
      elsif dealer.busted?
        break
      else
        dealer_display("Dealer #{dealer.name} hits")
        dealer.dealt(deck.card_from_deck)
        display_dealer_hand
      end
    end
  end

  def player_turn
    puts ''
    puts 'Its your turn...'
    loop do
      puts MESSAGES['hit_or_stay'].center(80)
      answer = nil
      loop do
        answer = gets.chomp.downcase
        break if %w(h s).include?(answer)

        puts "Sorry, must enter 'h' or 's'."
      end

      break if human.busted?
      if answer == 's'
        puts 'You have decided to stay'
        break
      else
        human.dealt(deck.card_from_deck)
        puts 'You have decided to hit!'
        puts ''
        human_display('Your current hand is:')
        display_human_hand
        display_players_current_hand_value
        break if human.busted?
      end
    end
  end
end

game = Game.new
game.start
