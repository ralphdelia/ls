def bubble_sort!(array)
  loop do
    swapped = false
    1.upto(array.size - 1) do |index|
      first, second = yield(array[index - 1]), yield(array[index])
      next if first <= second
      array[index - 1], array[index] = array[index], array[index - 1]
      swapped = true
    end

    break unless swapped
  end
end


array = %w(sue Pete alice Tyler rachel Kim bonnie)
bubble_sort!(array) { |value| value.downcase }
p array == %w(alice bonnie Kim Pete rachel sue Tyler)