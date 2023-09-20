def reduce(array, acc=0)
  counter = 0
  if array.first.instance_of?(String)
    acc = ''
  elsif array.first.instance_of?(Array)
    acc = []
  end

  while counter < array.size
    acc = yield(acc, array[counter])
    counter += 1
  end

  acc
end



array = [1, 2, 3, 4, 5]

p reduce(['a', 'b', 'c']) { |acc, value| acc += value }     # => 'abc'
p reduce([[1, 2], ['a', 'b']]) { |acc, value| acc + value } # => [1, 2, 'a', 'b']

p reduce(array) { |acc, num| acc + num }                    # => 15
p reduce(array, 10) { |acc, num| acc + num }                # => 25

reduce(array) { |acc, num| acc + num if num.odd? }        # => NoMethodError: undefined method `+' for nil:NilClass