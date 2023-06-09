def buff(array, new_element)
  array << [new_element]
end


arr = %w(1 2 3)

p buff(arr, '4')

p arr