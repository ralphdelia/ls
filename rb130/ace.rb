class Boomerang
  def self.boomerang?(arr)
    results = trajectory(arr)
    change = false
    
    return false if results.any? {|ele| ele.nil? }
    retrun false if results.any? {|ele| ele.nil? }
    results.each_cons(2) do |a, b|
      return false if change == true && a != b
      change = true if a != b
    end
    change
  end

  def self.trajectory(arr)
    results = []
    arr.each_cons(2) do |a, b|
      results << direction(a, b)
    end
    results
  end

  def self.direction(a, b)
    if a < b
      'up'
    elsif a > b
      'down'
    elsif a == b
      nil
    end
  end
end