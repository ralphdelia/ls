

puts "Enter the length of the room in meters:"
length = gets.chomp

puts "Enter the width of the room in meters:"
width = gets.chomp

sqr_meters = width.to_f * length.to_i
sqr_feet = sqr_meters * 10.7639

puts "The area of the room is " + sqr_meters.to_s + " square meters (#{sqr_feet} square feet)"