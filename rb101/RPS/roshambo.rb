VALID_CHOICES = %w(rock paper scissors spock lizard)

WIN_INDEX = { 'lizard' => ['spock', 'paper'],
              'spock' => ['rock', 'scissors'],
              'rock' => ['lizard', 'scissors'],
              'paper' => ['spock', 'rock'],
              'scissors' => ['lizard', 'paper'] }

# PROMPT
def prompt(message)
  puts "=> #{message}"
end

def prompt_choice
  choice = ''
  loop do
    prompt("Choose one: #{VALID_CHOICES.join(', ')}")
    prompt('You have the option to select either the full name or use the' \
           'abbreviations l, sp, r, p, or sc.')
    choice = gets.chomp

    break if VALID_CHOICES.include?(choice)

    if choice.downcase == 's' then choice = clarify_for_s end

    if valid_first_letters?(choice)
      choice = letter_to_string(choice)
      break
    end
    prompt('Thats not a valid input')
  end
  choice
end

# VALIDATE
def valid_first_letters?(letters)
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

def win?(first, second)
  first_defeats = WIN_INDEX[first]
  first_defeats.include?(second)
end

# DISPLAY
def display_results(player, computer)
  if win?(player, computer)
    puts 'You won'.center(51)
  elsif win?(computer, player)
    puts 'Computer won'.center(51)
  else
    puts 'Its a tie'.center(51)
  end
end

def display_current(score)
  puts '-' * 51
  puts "***You have #{score[:player]} points, the computer has" \
       " #{score[:computer]} points.***"
  puts '-' * 51
end

def display_match(winner)
  winner = winner.keys[0].to_s
  if winner == 'player'
    prompt('You won the match!')
  elsif winner == 'computer'
    prompt('The computer won the match!')
  end
end

# UPDATE
def update_match(score, player, computer)
  if win?(player, computer)
    score[:player] += 1
  elsif win?(computer, player)
    score[:computer] += 1
  end
end

def clarify_for_s
  choice = ''
  loop do
    prompt("'s' is not a valid input!")
    prompt("Please choose 'sp' for spock or 'sc' for scissors.")
    choice = gets.chomp

    break if choice == 'sc' || choice == 'sp'
  end
  choice
end

loop do
  score = { player: 0, computer: 0 }
  loop do
    choice = prompt_choice
    computer_choice = VALID_CHOICES.sample
    
    system 'clear'
    puts '-' * 51
    puts "You chose #{choice}; Computer chose: #{computer_choice}".center(51)
    display_results(choice, computer_choice)

    update_match(score, choice, computer_choice)
    display_current(score)

    winner = score.select { |_, value| value >= 3 }
    if !winner.empty?
      display_match(winner)
      break
    end
  end

  prompt("Do you want to play again?")
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt("Thank you for playing goodbye!")
