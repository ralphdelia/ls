def prompt(number)
  puts 'Enter the ' + number
end

def get_user_number
  number = gets.chomp.to_i
end

array = []

prompt('1st number:')
array.push(get_user_number)

prompt('2nd number:')
array.push(get_user_number)

prompt('3rd number:')
array.push(get_user_number)

prompt('4th number:')
array.push(get_user_number)

prompt('5th number:')
array.push(get_user_number)

prompt('final number:')
search_number = gets.chomp.to_i

if array.include?(search_number)
  puts "The number #{search_number} appears in #{array}" 
else 
  puts "The number #{search_number} does not appear in #{array}"
end
