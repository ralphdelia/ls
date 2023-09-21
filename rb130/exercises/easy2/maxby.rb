def max_by(array)
  return nil if array.empty? 

  max_arg = array.first
  max_block_value = yield(max_arg)

  array[1..-1].each do |ele|
    block_value = yield(ele)
    if block_value > max_block_value
      max_block_value = block_value
      max_arg = ele
    end
  end
  max_arg
end

p max_by([1, 5, 3]) { |value| value + 2 } == 5
p max_by([1, 5, 3]) { |value| 9 - value } == 1
p max_by([1, 5, 3]) { |value| (96 - value).chr } == 1
p max_by([[1, 2], [3, 4, 5], [6]]) { |value| value.size } == [3, 4, 5]
p max_by([-7]) { |value| value * 3 } == -7
p max_by([]) { |value| value + 5 } == nil 
