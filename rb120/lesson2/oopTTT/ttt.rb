# frozen_string_literal: true

require 'pry'
module Displable
  def joinor(array, delimiter = ', ', word = 'or')
    if array.size < 2
      array.first.to_s
    elsif array.size < 3
      array.join(" #{word} ")
    else
      final_word = "#{delimiter}#{word} #{array.last}"
      array[0..-2].join(delimiter) + final_word
    end
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    @squares = {}
    reset
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      return squares.first.marker if three_identical_markers?(squares)
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts '     |     |'
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts '     |     |'
  end
  # rubocop:enable Metrics/AbcSize

  def winning_move_availbale?(marker)
    !!return_imminent_third_match(marker)
  end

  def return_imminent_third_match(marker)
    WINNING_LINES.each do |line|
      winning_line_values = @squares.values_at(*line).collect(&:marker)
      next unless winning_line_values.count(marker) == 2 &&
                  winning_line_values.count(' ') == 1

      index = winning_line_values.index(' ')
      return line[index]
    end
    nil
  end

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3

    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = ' '

  attr_accessor :marker

  def initialize(marker = INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  include Displable

  attr_accessor :name, :marker
end

class Computer < Player
  def computer_choose_marker(human_marker)
    mark = human_marker == 'O' ? 'X' : 'O'
    self.marker = mark
  end

  def prompt_choose_advisary
    opponents = %w[Moe Larry Curly]
    choice = ''
    loop do
      puts "=> Choose your oponent: #{joinor(opponents)}"
      choice = gets.chomp

      break if opponents.include?(choice.capitalize)

      puts 'invalid input'
    end
    self.name = choice.capitalize
  end
end

class User < Player
  def prompt_name
    puts '=> What is your name?'
    self.name = gets.chomp.capitalize
  end

  def prompt_marker
    answer = ''
    loop do
      puts '=> What mark would you like to use?'
      puts "(You can choose any letter A-Z. eg. 'X', 'O')"
      answer = gets.chomp
      answer = answer.strip.upcase

      break if ('A'..'Z').to_a.include?(answer)

      puts 'Thats not a valid choice.'
    end

    self.marker = answer
  end
end

class Score
  WINNING_SCORE = 3
  attr_accessor :board

  def initialize(player1, player2)
    @board = init_board(player1, player2)
  end

  def init_board(player1, player2)
    hash = {}
    [player1, player2].each { |player| hash[player] = 0 }
    hash
  end

  def update(player)
    board[player] += 1
  end

  def display
    puts '____Score____'
    board.to_a.each do |player, score|
      puts "  #{player}: #{score}"
    end
  end

  def winner?
    board.values.any? { |score| score >= WINNING_SCORE }
  end

  def leading_player
    board.max_by { |_, v| v }.first
  end
end

class TTTGame
  HUMAN_MARKER = 'X'
  COMPUTER_MARKER = 'O'
  FIRST_TO_MOVE = HUMAN_MARKER

  include Displable

  attr_reader :board, :human, :computer
  attr_accessor :score

  def initialize
    @board = Board.new
    @human = User.new
    @computer = Computer.new
    @current_marker = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message

    initialize_names_and_markers
    initialize_score_state

    main_game

    display_game_winner if score.winner?
    display_goodbye_message
  end

  private

  def initialize_names_and_markers
    human.prompt_name
    computer.prompt_choose_advisary
    human.prompt_marker
    computer.computer_choose_marker(human.marker)
  end

  def initialize_score_state
    @score = Score.new(human.name, computer.name)
  end

  def main_game
    loop do
      display_board
      player_move
      update_score
      display_result

      break if score.winner?
      break unless play_again?

      reset
      display_play_again_message
    end
  end

  def player_move
    loop do
      current_player_moves
      break if board.someone_won? || board.full?

      clear_screen_and_display_board if human_turn?
    end
  end

  def update_score
    winner = player_name_by_marker(board.winning_marker)
    score.update(winner)
  end

  def player_name_by_marker(marker)
    player = [human, computer].select { |p| p.marker == marker }
    player.first.name
  end

  def display_welcome_message
    puts 'Welcome to Tic Tac Toe!'.center(37)
    puts ''
    puts 'First person to win three games wins!'
    puts ''
  end

  def display_game_winner
    puts "#{score.leading_player.upcase} WON!!!"
  end

  def display_goodbye_message
    puts 'Thanks for playing Tic Tac Toe! Goodbye!'
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def human_turn?
    @current_marker == HUMAN_MARKER
  end

  def display_board
    puts "You're a #{human.marker}. #{computer.name} is a #{computer.marker}."
    puts ''
    board.draw
    puts ''
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)

      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    square = if board.winning_move_availbale?(computer.marker)
               board.return_imminent_third_match(computer.marker)
             elsif board.winning_move_availbale?(human.marker)
               board.return_imminent_third_match(human.marker)
             else
               board.unmarked_keys.sample
             end

    board[square] = computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = COMPUTER_MARKER
    else
      computer_moves
      @current_marker = HUMAN_MARKER
    end
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts 'You won!'
    when computer.marker
      puts 'Computer won!'
    else
      puts "It's a tie!"
    end
    score.display
  end

  def play_again?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp.downcase
      break if %w[y n].include? answer

      puts 'Sorry, must be y or n'
    end

    answer == 'y'
  end

  def clear
    system 'clear'
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ''
  end
end

game = TTTGame.new
game.play
