def some_method(arr)
  counter = 0
  new_arr = []
  while counter < arr.size
    new_arr << yield(arr[counter])
    counter += 1
  end

  new_arr
end

arr = %w(1 2 3 4 5 6)
p some_method(arr, &:to_i)
p arr