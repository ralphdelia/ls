=begin
  
class Perfect number 

class method classify 
  positve in only 
  return standard error for negative number

  need to have a helper method that calcualtes the aliqout sum
  classify does the classification

=end

class PerfectNumber
  
  def self.classify(num)
    raise StandardError if num < 0
    aliquot_sum = sum_of_divisors(num)

    if aliquot_sum > num 
      'abundant'
    elsif aliquot_sum < num 
      "deficient"
    elsif aliquot_sum == num 
      'perfect'
    end
  end

  def self.sum_of_divisors(number)
    divisors = []
    1.upto(number - 1) do |num|
      divisors << num if number % num  == 0
    end
     divisors.sum 
  end
end
