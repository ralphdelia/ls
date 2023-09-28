require "minitest/reporters"
Minitest::Reporters.use!

class BeerSong
  LAST_VERSE = "No more bottles of beer on the wall, no more bottles of beer.\n" \
  "Go to the store and buy some more, 99 bottles of beer on the wall.\n"

  def self.verses(verse_a, verse_b)
    str = ''
   verse_a.downto(verse_b) do |num| 
      str << return_verse(num) 
      str << "\n" if num != verse_b 
    end
    str
  end

  def self.verse(arg)
    return_verse(arg)
  end

  def self.return_verse(num)
    verse = "#{num} bottles of beer on the wall, #{num} bottles of beer.\n" \
    "Take one down and pass it around, #{num - 1} bottles of beer on the wall.\n"
      case num 
      when 3..99
        verse
      when 2
        verse.gsub(/1\sbottles/, '1 bottle')
      when 1
        verse.lines.first.gsub(/1\sbottles/, '1 bottle') +
        "Take it down and pass it around, no more bottles of beer on the wall.\n"
      when 0  
        LAST_VERSE
      end
  end

  def self.lyrics
    verses(99, 0)
  end

end

p BeerSong.verses(99, 98)