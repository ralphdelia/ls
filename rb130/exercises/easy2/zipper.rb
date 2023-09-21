def zip(arr1, arr2)
  arr1.map.each_with_index do |ele, index|
    [ele, arr2[index]]
  end
end

p zip([1, 2, 3], [4, 5, 6]) == [[1, 4], [2, 5], [3, 6]]