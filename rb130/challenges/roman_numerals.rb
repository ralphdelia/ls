=begin
 
input is roman numeral 

output is a roman numeral 
  * capital letter 


  

we have these ranges where the rules are
  number single number on the 5s or 10
  X (1, 5, 10, 50, 100, 500)
  number comes after 10 or 5 addition
  XI  1 2 3 6 7 8
  XII
  XIII 
  number come right before 10 or 5 for subtraction 
  IL 4 9
  


=end




reversed_roman_numerals = {
  "I" => 1,
  "V" => 5,
  "X" => 10,
  "L" => 50,
  "C" => 100,
  "D" => 500,
  "M" => 1000
}




number = 2035
values = []
while number > 0
  values << (number % 10) 
  number /= 10
end
hash = {}
values.each_with_index do |value, index|
  hash[value] = 10**index
end

p hash