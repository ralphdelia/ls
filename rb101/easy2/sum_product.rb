puts ">> Please enter an integer greater than 0:"
int = gets.chomp.to_i 
range = (1..int).to_a

puts ">> Enter 's' to compute the sum, 'p' to compute the product."
operation = gets.chomp.downcase

if operation == 's'
  result = range.reduce{ |total, current| total + current }
  puts "The sum of the integers between 1 and #{int} is #{result}"
elsif operation == 'p'
  result = range.reduce{ |total, current| total * current }
  puts "The sum of the integers between 1 and #{int} is #{result}"
end
