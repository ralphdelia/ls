=begin
find the multiples using 

if we are give multiples use them 
else use 3 and 5 
  

  to method 
  a limiting value 
  calcuates the multiples of the provide / default list 

  calculate the using the multiples upto but not including the limiting value 
  then sum them and return 

=end


class SumOfMultiples
  attr_reader :set
  def initialize(*args)
    @set = args.empty? ? [3, 5] : args
  end

  def to(limit)
  end
  
end


