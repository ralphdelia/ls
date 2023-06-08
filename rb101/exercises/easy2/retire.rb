t = Time.now

puts "What is your age?"
age = gets.to_i

puts "At what age would you like to retire?"
retirement_age = gets.to_i

years_to_go = retirement_age - age
retirement_year = years_to_go + t.year

puts "Its #{t.year}. You will retire in #{retirement_year}"
puts "You have only #{years_to_go} years of work to go!"