
def stringy(num)
  string = ""
  counter = 0

  loop do 
    string =  string + (counter.even? ? "1" : "0")
    counter += 1 
    break if counter == num
  end
  return string 
end

puts stringy(6) == '101010'
puts stringy(9) == '101010101'
puts stringy(4) == '1010'
puts stringy(7) == '1010101'