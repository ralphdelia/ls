VALID_CHOICES = %w(rock paper scissors spock lizard)

def validate_choice?(letters)
  valid = false
  VALID_CHOICES.each do |element|
    valid = true if element[0] == letters || element[0..1] == letters
  end
  valid
end

def letter_to_string(letter) 
  word = ""
  VALID_CHOICES.each do |element|
    word = element if element[0] == letter || element[0..1] == letter
  end
  word
end

def prompt(message)
  puts "=> #{message}"
end

def win?(first, second)
  case first
  when 'rock'
    second == "lizard" || second == "scissors"
  when 'paper'
    second == "spock" || second == 'rock'
  when 'scissors'
    second == 'lizard' || second == 'paper'
  when 'spock'
    second == 'rock' || second == 'scissors'
  when 'lizard'
    second == 'spock' || second == 'paper'
  end
end

def display_results(player, computer)
  if win?(player, computer)
    prompt 'You won'
  elsif win?(computer, player)
    prompt 'Computer won'
  else
    prompt('Its a tie')
  end
end

def update_match(score, player, computer)
  if win?(player, computer)
    score[:player] += 1
  elsif win?(computer, player)
    score[:computer] += 1
  end
end

def display_match(score)
  prompt("You have #{score[:player]} points, the computer has #{score[:computer]} points.")
end

loop do
  choice = ""
  score = {player: 0, computer: 0}
  loop do
    loop do
      prompt("Choose one: #{VALID_CHOICES.join(', ')}")
      choice = gets.chomp

      if validate_choice?(choice)
        break
      else
        prompt("That's not a valid choice.")
      end
    end

    choice = letter_to_string(choice)
    choice_computer = VALID_CHOICES.sample
    
    puts "You chose #{choice}; Computer chose: #{choice_computer}"
    display_results(choice, choice_computer)

    update_match(score, choice, choice_computer)
    display_match(score)

    winner = score.select { |_, score| score >= 3 }
    
    if !winner.empty?
      winner = winner.keys[0].to_s
      prompt( winner == "player" ? "You Won the match!" : "The computer won the match!" )      
      break
    end 
  end

  prompt("Do you want to play again?")
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt("Thank you for playing goodbye!")
