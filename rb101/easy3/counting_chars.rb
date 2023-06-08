

puts 'Please write word or multiple words:'
input = gets.chomp

count = 0 
input.split.each do |element|
  count += element.size
end
puts "There are #{count} characters in '#{input}'"