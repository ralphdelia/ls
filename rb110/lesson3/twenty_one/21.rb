require 'pry'
LINES = [
  "┌─────────┐┌─────────┐",
  "│2        ││1        │",
  "│         ││         │",
  "│         ││         │",
  "│    ♥    ││    ♥    │",
  "│         ││         │",
  "│         ││         │",
  "│        2││        1│",
  "└─────────┘└─────────┘",
  " Welcome to Twenty-One",
  "Lets see who can reach three wins first."
]
ACE_INDEX = {1=>[11, 1], 2=>[22, 12, 2], 3=>[33, 23, 13, 3], 4=>[44, 34, 24, 14, 4]}

def start_screen
  system 'clear'
  LINES.each do |line|
    puts line.center(42)
  end

  str = ''
  12.times do
    str << "--"
    system 'clear'
    LINES.each do |line|
      puts line.center(42)
    end
    puts str.center(42)
    sleep(0.1)
  end
end

def prompt(msg)
  puts "=> #{msg}"
end

def joinor(arr)
  if arr.size == 2
    arr.join(" and ")
  else
    "#{arr[0..-2].join(', ')}, and #{arr.last}"
  end
end

def continue?
  loop do
    prompt "---------------------------------------"
    prompt ""
    prompt "type 'start' to continue or 'exit' to quit"
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

def hit!(hand, deck)
  card = deck.delete(deck.sample)
  hand.push(card.last)
end

def deal_hand!(deck)
  arr = []
  2.times do
    card = deck.delete(deck.sample)
    arr.push(card.last)
  end
  arr
end

def boarder
  puts '-' * 42
end

def display_hands(player, dealer)
  boarder
  prompt "Dealer has: #{dealer.first} and unknown card"
  prompt "You have: #{joinor(player)}"
end

def display_final_hand(player, dealer)
  prompt "Dealer has: #{joinor(dealer)}"
  prompt "You have: #{joinor(player)}"
  puts 'Dealer busted!'.center(42) if busted?(dealer)
  puts 'You busted!'.center(42) if busted?(player)
end

def return_non_ace_values(hand)
  hand.map do |element|
    if element.to_i.to_s == element
      element.to_i
    elsif %w(jack queen king).include?(element)
      10
    else
      element
    end
  end
end

def calculate_ace_value(hand_value, number_of_aces)
  ace_values = ACE_INDEX[number_of_aces]
  summed_hand_values = ace_values.map { |value| value + hand_value }
  valid_hand_values = summed_hand_values.select { |values| values <= 21 }
  if valid_hand_values.empty? # if busted
    -1
  else
    valid_hand_values.max
  end
end

def calculate_hand(hand)
  hand = return_non_ace_values(hand)

  if hand.include?('ace')
    aces, integers = hand.partition { |card| card == 'ace' }

    return calculate_ace_value(integers.sum, aces.size)
  end

  hand.reduce(:+)
end

def valid_answer?(answer)
  answer == 'stay' || answer == 'hit'
end

def hit_or_stay
  answer = ''
  loop do
    boarder
    puts "hit or stay?".center(42)
    boarder
    answer = gets.chomp.downcase

    break if valid_answer?(answer)
    prompt "Thats not a valid answer."
  end
  answer
end

def busted?(player)
  calculate_hand(player) > 21 ||
    calculate_hand(player) == -1
end

def player_turn(player_hand, dealer_hand, deck)
  loop do
    answer = hit_or_stay

    hit!(player_hand, deck) if answer == 'hit'

    display_hands(player_hand, dealer_hand)
    break if answer == 'stay' || busted?(player_hand)
  end
end

def dealer_turn(dealer_hand, player_hand, deck)
  return if busted?(player_hand)
  loop do
    prompt "Dealers turn..."
    sleep(1)
    comp_hand_value = calculate_hand(dealer_hand)

    hit!(dealer_hand, deck) if comp_hand_value < 17

    break if comp_hand_value >= 17 || busted?(dealer_hand)
  end
end

def tie?(results)
  results[:player] == results[:dealer] ||
    (results[:player] > 21 && results[:dealer] > 21)
end

def return_winner(results)
  return 'tie' if tie?(results)

  valid_results = results.select { |_k, v| v <= 21 }
  highest_hand = valid_results.max_by { |_, v| v }
  highest_hand.first.to_s
end

def display_match(winner)
  prompt "---------------------------------------"
  if winner == 'tie'
    puts "Its a draw!".center(42)
  else
    puts "#{winner.capitalize} won!".center(42)
  end
end

def increment_score(winner, score)
  case winner
  when 'player'
    score[:player] += 1
  when 'dealer'
    score[:dealer] += 1
  end
end

def display_game(score)
  puts "You have #{score[:player]} wins".center(42)
  puts "Dealer has #{score[:dealer]} wins".center(42)
end

def game_winner?(score)
  score[:player] == 3 || score[:dealer] == 3
end

def display_game_winner(score)
  if score[:player] == 3
    puts "Congratulations you won the match!".center(42)
  elsif score[:dealer] == 3
    puts "Dealer won the match!".center(42)
  end
end

loop do
  start_screen
  break if continue?
end

score = { player: 0, dealer: 0 }
loop do
  deck = initialize_deck

  player_hand = deal_hand!(deck)
  dealer_hand = deal_hand!(deck)
  display_hands(player_hand, dealer_hand)

  player_turn(player_hand, dealer_hand, deck)
  dealer_turn(dealer_hand, player_hand, deck)

  display_final_hand(player_hand, dealer_hand)

  final_results = { player: calculate_hand(player_hand),
                    dealer: calculate_hand(dealer_hand) }
  match_winner = return_winner(final_results)

  increment_score(match_winner, score)

  display_match(match_winner)
  display_game(score)

  break if game_winner?(score)
  continue?
end
display_game_winner(score)
puts 'Thanks for playing goodbye!'.center(42)
