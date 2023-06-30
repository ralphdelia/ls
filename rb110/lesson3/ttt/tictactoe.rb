INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = '0'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

def prompt(msg)
  puts "=> #{msg}"
end

def fancy_display
  puts '__  _______  _____ '.center(42)
  puts '\ \/ / _ \ \/ / _ \ '.center(42)
  puts ' >  < (_) >  < (_)|'.center(42)
  puts '/_/\_\___/_/\_\___/ '.center(42)
end

def display_board(brd)
  system 'clear'
  puts "You are a #{PLAYER_MARKER}, the computer " \
       "is a #{COMPUTER_MARKER}".center(42)
  puts ""
  puts "     |     |     ".center(42)
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  ".center(42)
  puts "     |     |     ".center(42)
  puts "-----+-----+-----".center(42)
  puts "     |     |     ".center(42)
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  ".center(42)
  puts "     |     |     ".center(42)
  puts "-----+-----+-----".center(42)
  puts "     |     |     ".center(42)
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  ".center(42)
  puts "     |     |     ".center(42)
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a position to place a piece: #{joinor(empty_squares(brd))}"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)

    prompt 'Sorry, thats not a valid choice.'
  end

  brd[square] = PLAYER_MARKER
end

def select_unmarked_position(line, board)
  line.select { |num| board[num] == " " }.first
end

def detect_defensive_placement(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 2 &&
       brd.values_at(*line).count(COMPUTER_MARKER) == 0
      return select_unmarked_position(line, brd)
    end
  end
  nil
end

def detect_winning_placement(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(COMPUTER_MARKER) == 2 &&
       brd.values_at(*line).count(INITIAL_MARKER) == 1
      return select_unmarked_position(line, brd)
    end
  end
  nil
end

def detect_center_square(brd)
  5 if brd[5] == INITIAL_MARKER
end

def random_square(brd)
  empty_squares(brd).sample
end

def computer_places_piece!(brd)
  square = detect_winning_placement(brd) ||
           detect_defensive_placement(brd) ||
           detect_center_square(brd) ||
           random_square(brd)

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def increment_score(brd, score)
  if detect_winner(brd) == "Player"
    score[:player] += 1
  elsif detect_winner(brd) == 'Computer'
    score[:computer] += 1
  end
end

def joinor(arr, delimiter=', ', word='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first.to_s
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
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

def display_current(score)
  prompt "The score is Player: #{score[:player]} Computer: #{score[:computer]}"
end

def detect_match_winner(score)
  if score[:player] == 5
    return 'Player'
  elsif score[:computer] == 5
    return 'Computer'
  end
  nil
end

def validate_answer(answer)
  return true if answer == 'player' || answer == 'computer'
end

def determine_first_player
  first_player = ''
  system 'clear'
  loop do
    prompt "Who should go first, player or computer? " \
           "(Enter 'pass' to let the computer choose): "
    first_player = gets.chomp
    first_player = first_player.downcase

    first_player = ['player', 'computer'].sample if first_player == 'pass'

    break if validate_answer(first_player)
    prompt "Invalid input. Please enter 'player', 'computer' or 'pass'."
  end
  first_player
end

def start_screen
  loop do
    system 'clear'
    fancy_display
    puts ''
    puts "Hello and welcome to Tic Tac Toe.".center(42)
    puts "Lets play best out of five!".center(42)

    break if continue?
  end
end

def place_piece!(board, current_player)
  if current_player == 'player'
    player_places_piece!(board)
  elsif current_player == 'computer'
    computer_places_piece!(board)
  end
end

def alternate_player(current_player)
  return 'computer' if current_player == 'player'
  return 'player' if current_player == 'computer'
end

start_screen

loop do
  current_player = determine_first_player
  score = { player: 0, computer: 0 }

  loop do
    board = initialize_board

    loop do
      display_board(board)
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board(board)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won!"
    else
      prompt "It's a tie!"
    end

    increment_score(board, score)
    display_current(score)
    break if !!detect_match_winner(score)
    continue?
  end
  system 'clear'
  display_current(score)
  prompt "The winner of the match is #{detect_match_winner(score)}!"
  continue?
end
