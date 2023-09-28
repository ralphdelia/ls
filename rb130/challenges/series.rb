
class  Series
  def initialize(series)
    @series = series.split('').map(&:to_i)
  end

  def slices(int)
    raise ArgumentError if int > @series.size
    arr = []
    @series.each_cons(int){ |ele| arr << ele }
    arr
  end
end

