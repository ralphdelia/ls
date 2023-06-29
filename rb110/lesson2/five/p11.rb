arr = [[2], [3, 5, 7, 12], [9], [11, 13, 15]]

# iterate over the arrays within the parent array
# iterate over the integers within the array and only return the 
# ones that are divisible by 3

x = arr.map do |array|
  array.select do |int|
    int % 3 == 0 
  end
end

 p x