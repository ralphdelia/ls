
number = 4


def calculate_highest_sum(number) 
  values = [1, 11]
  combinations = []
  values.repeated_permutation(number) {|combination| combinations.push(combination)}
  sums = combinations.map { |arr| arr.reduce(:+) }
  sorted_sums = x.sort {|a, b| b <=> a}
  sorted_sums
end

x = x.map {|element| element + other_number }
x = x.select {|element| element <= 21}
x = x.max


