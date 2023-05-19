def float?(input)
  input.to_f.to_s == input
end

def integer?(input)
  input.to_i.to_s == input
end

def valid_number?(input)
  integer?(input) || float?(input)
end

x = gets.chomp

puts float?(x)
puts valid_number?(x)
puts x
