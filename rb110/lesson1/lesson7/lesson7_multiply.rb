

def multiply(array, multiple)
  counter = 0
  multiplied_array = []


  loop do 
  break if counter >= array.size
  
  current_element = array[counter]
  multiplied_array << current_element *= multiple
  
  counter += 1
  end
  multiplied_array
end



my_numbers = [1, 4, 3, 7, 2, 6]
p multiply(my_numbers, 3) == [3, 12, 9, 21, 6, 18]