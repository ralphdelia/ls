

array = %w(4 5 3 5 3)



def pairs(array)
  array = array.select do |element|
    array.count(element) > 1
  end
  
  array.uniq.all? do |element|
    array.count {|ele| ele == element } == 2
  end
end


def two_pair?
  pairs = hand.uniq.select do |card|
    hand.count {|card2| card2.equal_rank?(card.rank) } == 2
  end
  pairs.uniq.size == 2
end

p pairs(array)