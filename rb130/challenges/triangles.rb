class Triangle
  def initialize(side_a, side_b, side_c)
    argument_values = [side_a, side_b, side_c]
    valid_sides?(argument_values) && 
    valid_values?(argument_values)

    @triangle = argument_values
  end
    
  def kind
    if equilateral? 
      'equilateral'
    elsif isosceles? 
      'isosceles'
    elsif scalene?
      'scalene'
    end
  end

  private


  def valid_values?(values)
    if values.any? { |ele| ele <= 0 }
      raise ArgumentError
    end
  end

  def valid_sides?(values)
    side_a, side_b, side_c = values
    if side_a + side_b <= side_c ||
       side_b + side_c <= side_a ||
       side_c + side_a <= side_c
      raise ArgumentError
    end
  end

  def equilateral?
    side_a, side_b, side_c = @triangle
    side_a == side_b && side_b == side_c
  end

  def isosceles?
    side_a, side_b, side_c = @triangle
    side_a == side_b || 
    side_b == side_c || 
    side_a == side_c
  end

  def scalene?
    side_a, side_b, side_c = @triangle
    side_a != side_b && 
    side_b != side_c &&
    side_a != side_c
  end
end
