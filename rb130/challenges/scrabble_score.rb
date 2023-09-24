

class Scrabble
  LETTER_INDEX = {
    1 => %w[A E I O U L N R S T],
    2 => %w[D G],
    3 => %w[B C M P],
    4 => %w[F H V W Y],
    5 => %w[K],
    8 => %w[J X],
    10 => %w[Q Z]
  }.freeze

  def initialize(word)
    @word = word.nil? ? '' : word.upcase
  end

  def score
    total = 0
    @word.chars.each do |char|
      LETTER_INDEX.each do |value, letters|
        total += value if letters.include?(char)
      end
    end
    total
  end

  def self.score(arg)
    new(arg).score
  end
end

