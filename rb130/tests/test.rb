class SomeColab
  def initialize
    @value = %w(1 2 3 4).sample 
  end
  
  def output
    puts @value
  end

end


class SomeClass
  def initialize()
    @arr = [Colab.new, Colab.new, Colab.new]
  end

  def each
    @arr.each {|ele| yield(ele)}
  end


end

SomeClass.new.each(&:output)