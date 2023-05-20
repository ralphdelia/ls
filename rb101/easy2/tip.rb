

puts "What is the bill?"
amount = gets.to_i

puts "What is the tip percentage?"
percent = gets.to_f / 100

tip = (amount * percent).round(1)
total = (amount + tip).round(1)

puts "The tip is $" + tip.to_s
puts "The total is $" + total.to_s