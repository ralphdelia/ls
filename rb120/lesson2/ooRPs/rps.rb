require 'yaml'
MESSAGES = YAML.load_file('rps_messages.yml')

class Move
  VALUES = %w(rock paper scissors spock lizard).freeze
  WIN_INDEX = { 'rock' => ['lizard', 'scissors'],
                'lizard' => ['spock', 'paper'],
                'spock' => ['rock', 'scissors'],
                'scissors' => ['rock', 'lizard'],
                'paper' => ['rock', 'spock'] }

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def <=>(other)
    if WIN_INDEX[value].include?(other)
      1
    elsif WIN_INDEX[other].include?(value)
      -1
    else
      0
    end
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
  end

  def string_state
    "#{name} chose #{move}"
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts 'Whats your name?'
      n = gets.chomp
      break unless n.empty?

      puts 'Sorry must enter a value!'
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts 'Please choose rock, paper, spock, lizard or scissors:'
      choice = gets.chomp
      break if Move::VALUES.include?(choice)

      puts 'Sorry, invalid choice.'
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = %w(R2D2 Moe Larry Curly).sample
  end

  def choose
    self.move = Move::VALUES.sample
  end
end

class History
  attr_accessor :record, :turn

  def initialize
    @turn = 1
    @record = {}
  end

  def file(player, computer, winner, score)
    time = Time.new
    record[turn] = { time: "#{time.hour}:#{time.min}",
                     moves: [player, computer],
                     winner: winner,
                     score: score.dup }
    self.turn += 1
  end

  def display
    puts "Game History:"
    record.each do |turn, data|
      puts "Turn #{turn}:"
      puts "  Time: #{data[:time]}"
      puts "  Player Move: #{data[:moves][0]}"
      puts "  Computer Move: #{data[:moves][1]}"
      puts "  Winner: #{data[:winner]}"
      puts "  Score: #{data[:score]}"
      puts
    end
  end
end

module Display
  def display_rules
    MESSAGES['rules'].each do |r|
      sleep(0.05)
      puts r.center(53)
    end
  end

  def display_turn
    display_moves
    display_winner
    score.display
  end

  def display_match_results
    puts "#{score.leader} has won the match!" if winner?
  end

  def show_rules?
    answer = ''
    loop do
      puts 'Do you need a tour of the rules? (y/n)'.center(53)
      answer = gets.chomp

      break if %(y n).include?(answer)
      puts 'Invalid input please use (y/n)'
    end

    true if answer == 'y'
  end

  def display_welcome
    system 'clear'
    puts "Hello #{human.name}!".center(53)
    MESSAGES['welcome'].each { |w| puts w.center(53) }

    display_rules if show_rules?
  end

  def display_goodbye_message
    puts 'Thanks for playing!'
  end

  def countdown_shoot
    MESSAGES['shoot'].each do |m|
      sleep(0.5)
      puts m.center(53)
    end
  end

  def spacer
    puts "~" * 53
  end

  def display_moves
    countdown_shoot
    spacer
    puts format(MESSAGES['moves'], name: "You", move: human.move).center(53)
    puts format(MESSAGES['moves'], name: computer.name,
                                   move: computer.move).center(53)
    spacer
  end

  def display_winner
    if round_winner == 'tie'
      puts "Its a tie".center(53)
    else
      puts "#{round_winner} won!".center(53)
    end
  end
end

class RPSGame
  include Display

  attr_accessor :human, :computer, :score, :round_winner, :record

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new(player_names)
    @record = History.new
  end

  def player_names
    [human.name, computer.name]
  end

  def determine_winner
    case human.move <=> computer.move
    when 1
      self.round_winner = human.name
    when -1
      self.round_winner = computer.name
    when 0
      self.round_winner = 'tie'
    end
  end

  def winner?
    score.player_values.any? { |v| v >= Score::TO_WIN }
  end

  def stop_playing?
    answer = nil
    loop do
      puts 'Would you like to play again? (y/n)'
      answer = gets.chomp
      break if %w(y n).include?(answer.downcase)

      puts 'Sorry, must be y or n'
    end

    return true if answer.downcase == 'n'
    return false if answer.downcase == 'y'
  end

  def game_history?
    answer = ''
    loop do
      puts 'Do you want to see a record of the game history? (y/n)'
      answer = gets.chomp
      break if %w(y n).include?(answer.downcase)
      puts "Invalid input use (y/n)"
    end
    record.display if answer.downcase == 'y'
  end

  def display_turn
    display_moves
    display_winner
    score.display
  end

  def update_turn
    determine_winner
    score.update(round_winner)
    record.file(human.string_state,
                computer.string_state,
                round_winner,
                score.player_points)
  end

  def turn
    loop do
      human.choose
      computer.choose

      update_turn
      display_turn
      break if winner? || stop_playing?
    end
  end

  def play
    display_welcome

    turn

    display_match_results
    game_history?
    display_goodbye_message
  end
end

class Score
  TO_WIN = 5

  attr_accessor :player_points
  attr_reader :players

  def initialize(players)
    @players = players
    @player_points = initialize_board(players)
  end

  def initialize_board(players)
    board = {}
    players.each { |name| board[name] = 0 }
    board
  end

  def player_values
    player_points.values
  end

  def leader
    player_points.max_by { |_, v| v }.first
  end

  def update(winner)
    return if winner == 'tie'
    player_points[winner] += 1
  end

  def blank_line
    puts ''
  end

  def display
    blank_line
    puts '______________Score______________'.center(53)
    blank_line
    player_points.each do |k, v|
      puts "#{k}: #{v}".center(53)
    end
    puts '_________________________________'.center(53)
    blank_line
  end
end

game = RPSGame.new
game.play
