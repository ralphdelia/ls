class DNA
  def initialize(strand)
    @strand = strand 
  end

  def hamming_distance(other_strand)
    if other_strand.size < @strand.size
      distance(other_strand, @strand)
    elsif @strand.size < other_strand.size
      distance(@strand, other_strand)
    else
      distance(@strand, other_strand) 
    end
  end
    
  private

  def distance(string_a, string_b)
    distance = 0
    string_a.chars.each_with_index do |char, index|
      distance += 1 if char != string_b[index]
    end
    distance 
  end
end
