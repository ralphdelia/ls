
class Octal
  def initialize(num)
    @num = num
  end

  def to_decimal
    return 0 unless valid_octal?(@num)

    numbers = @num.chars.map(&:to_i)

    numbers = numbers.map.each_with_index do |element, index|
      element * (8**(@num.length - index - 1))
    end

    numbers.sum
  end

  private

  def valid_octal?(num)
    nums = num.split('')

    if nums.any? { |char| char.to_i.to_s != char } ||
       nums.any? { |char| char.to_i >= 8 }
      return false
    end

    true
  end
end
