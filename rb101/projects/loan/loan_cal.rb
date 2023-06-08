def prompt(message)
  puts "=> #{message}"
end

def float?(input)
  input.to_f.to_s == input
end

def integer?(input)
  input.to_i.to_s == input
end

def valid_number?(input)
  integer?(input) || float?(input)
end


prompt("Hello welcome to the Morgage Calculator.")
loop do 
  amount  = ""
  loop do 
    prompt("How much is your loan for?")
    amount = gets.chomp

    amount = amount.split(",").join

    break if integer?(amount)
    prompt("Thats not a valid number.")
  end

  j = ""
  loop do 
    prompt("What is your (APR) monthly interest rate?")
    j = gets.chomp

    j.prepend("0") if j[0] == "."
    break if float?(j)
    prompt("Thats not a valid number. Please provide the APR in X.X format")
  end

  n = ""
  loop do 
    prompt("What is the duration of your loan in months?")
    n = gets.chomp

    break if valid_number?(n)
    prompt("Thats not a valid number.")
  end

  amount = amount.to_i
  j = j.to_f / 12
  n = n.to_i

  m = amount * (j / (1 - (1 + j)**(-n)))

  prompt("Your monthly payment is #{m.truncate(2)}")
  
  prompt("Would you like to calcualte again? Type 'y' to continue.")
  answer = gets.chomp
  break if answer.downcase != "y"
end

