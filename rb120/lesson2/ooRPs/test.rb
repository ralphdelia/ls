class Move
  VALUES = %w(rock paper scissors).freeze
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



p = Paper.new
r = Rock.new

puts p <=> r
