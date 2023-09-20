def one?(array)
  count = 0
  array.each { |ele| count += 1 if yield(ele) }
  count == 1
end


=begin
 if one element within the array resolves to truthy 
  
  if two false 
  if none false

    track the true responses 

=end




p one?([1, 3, 5, 6]) { |value| value.even? } == true  # -> true
p one?([1, 3, 5, 7]) { |value| value.odd? } == false    # -> false
p one?([2, 4, 6, 8]) { |value| value.even? } == false    # -> false
p one?([1, 3, 5, 7]) { |value| value % 5 == 0 } == true  # -> true
p one?([1, 3, 5, 7]) { |value| true } == false           # -> false
p one?([1, 3, 5, 7]) { |value| false } == false          # -> false
p one?([]) { |value| true } == false                     # -> false