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
      if three_identical_markers?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  private

  def three_identical_markers?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3
    markers.min == markers.max
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
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

  attr_accessor :name
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def prompt_name
    puts "What is your name?"
    self.name = gets.chomp.capitalize
  end

  def prompt_choose_advisary
    opponents = %w(Moe Larry Curly)
    choice = ''
    loop do 
      puts "Choose your oponent:"
      puts "#{joinor(opponents)}"
      choice = gets.chomp

      break if opponents.include?(choice.capitalize)
      puts "invalid input"
    end
    self.name = choice.capitalize
  end
end

class Score
  WINNING_SCORE = 3
  attr_accessor :board

  def initialize(p1, p2)
    @board = init_board(p1, p2)
  end

  def init_board(p1, p2)
    hash = {}
    [p1, p2].each { |player| hash[player] = 0 }
    hash
  end

  def update(player)
    self.board[player] +=1
  end

  def display
    puts '____Score____'
    board.to_a.each do |player, score|
      puts "  #{player}: #{score}"
    end
  end

  def winner?
    board.values.any? { |score| score >= WINNING_SCORE}
  end

  def leading_player
    board.max_by { |_, v| v }.first
  end
end

class TTTGame
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  FIRST_TO_MOVE = HUMAN_MARKER

  include Displable
  
  attr_reader :board, :human, :computer
  attr_accessor :score

  def initialize
    @board = Board.new
    @human = Player.new(HUMAN_MARKER)
    @computer = Player.new(COMPUTER_MARKER)
    @current_marker = FIRST_TO_MOVE
  end

  def play
    clear
    display_welcome_message
    #choosing names init scoreboard
    human.prompt_name
    computer.prompt_choose_advisary
    @score = Score.new(human.name, computer.name)
    
    main_game

    display_game_winner if score.winner?
    display_goodbye_message
  end

  private

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
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end

  def display_game_winner
    puts "#{score.leading_player.upcase} WON!!!"
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
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
    puts ""
    board.draw
    puts ""
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
    board[board.unmarked_keys.sample] = computer.marker
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
      puts "You won!"
    when computer.marker
      puts "Computer won!"
    else
      puts "It's a tie!"
    end
    score.display
  end

  

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def clear
    system "clear"
  end

  def reset
    board.reset
    @current_marker = FIRST_TO_MOVE
    clear
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end
end

game = TTTGame.new
game.play