# frozen_string_literal: true

class Diamond
  ALPHABET = ('A'..'Z').to_a

  def self.make_diamond(letter)
    letter_index = ALPHABET.index(letter)

    diamond = diamond_segments_to(letter_index)
    diamond += diamond_segments_from(letter_index - 1)

    diamond.map! { |segment| "#{segment.center(diamond.size)}\n" }
    diamond.join
  end

  def self.diamond_segments_to(number)
    segments = []
    0.upto(number) do |index|
      if index.zero?
        segments << 'A'
      else
        segments << ALPHABET[index] + ' ' * (index * 2 - 1) + ALPHABET[index]
      end
    end

    segments
  end

  def self.diamond_segments_from(number)
    segments = []
    number.downto(0) do |index|
      if index.zero?
        segments << 'A'
      else
        segments << ALPHABET[index] + ' ' * (index * 2 - 1) + ALPHABET[index]
      end
    end
    segments
  end
end
