require 'pry'
class Move
  VALUES = %w(rock paper scissors spock lizard).freeze
  WIN_INDEX = { 'rock' => ['lizard', 'scissors'],
                'lizard' => ['spock', 'paper'],
                'spock' => ['rock', 'scissors'],
                'scissors' => ['rock', 'lizard'],
                'paper' => ['rock', 'spock'] }

  attr_reader :value

  def <=>(other)
    if WIN_INDEX[@value].include?(other.value)
      1
    elsif WIN_INDEX[other.value].include?(@value)
      -1
    else 
      0
    end
  end

  def to_s
    @value
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
  end

end

class Rock < Move
  def initialize
    @value = 'rock'
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
  end
end

class Player
  attr_accessor :move, :name

  def initialize
    set_name
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
    self.move = return_collaborator(choice)
  end

  def return_collaborator(choice)
    case choice
    when 'scissors'
      Scissors.new
    when 'rock'
      Rock.new
    when 'paper'
      Paper.new 
    when 'lizard'
      Lizard.new
    when 'spock'
      Spock.new
    end
  end
end

class Computer < Player
  def set_name
    self.name = %w(R2D2 Moe Larry Curly).sample
  end

  def choose
    self.move = [Scissors.new, Paper.new, Rock.new, Spock.new, Lizard.new].sample
  end
end

class RPSGame
  attr_accessor :human, :computer, :score, :round_winner

  def initialize
    @human = Human.new
    @computer = Computer.new
    @score = Score.new(player_keys)
  end

  def display_welcome_message
    puts 'Welcome to RPS'
  end

  def display_goodbye_message
    puts 'Thanks for playing!'
  end

  def player_keys
    [human.name, computer.name]
  end

  def display_moves
    puts "#{human.name} chose #{human.move}"
    puts "#{computer.name} chose #{computer.move}"
  end

  def display_winner
    if round_winner == 'tie'
      puts "Its a tie"
    else
      puts "#{round_winner} won!"
    end
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

  def display_match_results
    puts "#{score.leader} has won the match!" if winner?
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose
      display_moves
      determine_winner
      display_winner

      score.update(round_winner)
      score.display

      break if winner? || stop_playing?
    end

    display_match_results
    display_goodbye_message
  end
end

class Score
  TO_WIN = 3

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

  def display
    puts '~Score~'
    player_points.each do |k, v|
      puts "#{k}: #{v}"
    end
  end
end

game = RPSGame.new
game.play
