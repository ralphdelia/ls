def triangle(n)
  spaces = n - 1
  n.times do |element| 
    puts "#{' ' * spaces}#{'*' * (element + 1)}"
    spaces -= 1 
  end
end

triangle(7)