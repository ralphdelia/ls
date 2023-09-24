# frozen_string_literal: true

class Anagram
  def initialize(word)
    @word = word
  end

  def match(array)
    array.select do |str|
      next if str.downcase == @word.downcase

      @word.downcase.split('').sort ==
        str.downcase.split('').sort
    end
  end
end
