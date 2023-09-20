def missing(array)
  missing_nums = []
  array[0].upto(array[-1]) do |num|
    missing_nums << num if !array.include?(num)
  end
  missing_nums
end



p missing([-3, -2, 1, 5]) == [-1, 0, 2, 3, 4]
p missing([1, 2, 3, 4]) == []
p missing([1, 5]) == [2, 3, 4]
p missing([6]) == []