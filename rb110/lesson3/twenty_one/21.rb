def prompt(msg)
  puts '=> ' + msg
end

def continue?
  loop do
    prompt "---------------------------------------"
    prompt ""
    prompt "type 'start' to begin or 'exit' to quit"
    answer = gets.chomp.downcase

    if answer == 'start'
      break
    elsif answer == 'exit'
      abort 'Thanks for playing!'
    end
    prompt "Thats not a valid input!"
  end
  true
end

def initialize_deck
  suits = %w(H D C S)
  values = %w(2 3 4 5 6 7 8 9 10 jack queen king ace)
  deck = []
  suits.each do |suit|
    values.each do |value|
      deck.push([suit, value])
    end
  end
  deck
end

def deal_hand!(deck)
  arr = []
  2.times do
    card = deck.delete(deck.sample)
    arr.push(card.last)
  end
  arr
end

def display_hands(player, dealer)
  system 'clear'
  prompt "Dealer has: #{dealer.first} and unknown card"
  prompt "You have: #{player.first} and #{player.last}"
end

def calculate_hand(hand)
  hand = hand.map do |element|
    if element.to_i.to_s == element
      element.to_i
    elsif %w(jack queen king).include?(element)
      10
    end
    element
  end
  # add in other value, sort out greater than 21 find max

  hand.reduce(:+)
end

deck = initialize_deck()

loop do 
  system 'clear'
  puts "Hello and welcome to the game."
  break if continue?
end

loop do 

  player_hand = deal_hand!(deck)
  dealer_hand = deal_hand!(deck)
  display_hands(player_hand, dealer_hand)
  
  p calculate_hand(player_hand) 
  break
end



=begin
The values of the aces should be responsive to new additions
8 ace ace should output 20

calculate highest sum

to do 
  add in other value
  sort out greater than 21
  find max


determine which one is closest to 21
greatest value thats less than 21







hit - add a new element to the hands array
calcualte again
winner


=end
