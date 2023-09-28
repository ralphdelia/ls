class SumOfMultiples
  attr_reader :set
  def initialize(*args)
    @set =  args
  end

  def to(limit)
    self.class.to(limit, @set)
  end
  
  def self.to(limit, set=[3, 5])
    multiples = []
    set.min.upto(limit - 1) do |num|
      if set.any? {|multiple| num % multiple == 0}
        multiples << num
      end
    end

    multiples.sum
  end
  
end
