class Game
  attr_accessor :guesses

  def initialize
    @number = (1..100).to_a.sample
    @guesses = 7
    puts number
  end

  def play
    loop do 
      break if guesses < 1
      display_guesses_remaining
      
      guess = prompt_guess
      update_guess_counter
      if guess == number
        display_winner
        break
      else 
        hint(guess)
      end
    end
    results 
  end

  def results 
    if guesses == 0
      puts "Your all out of guesses the number was #{number}"
    else
      puts 'You won!'
    end
  end

  def prompt_guess
    answer = nil
    loop do 
      puts "Enter a number between 1 and 100"
      answer = gets.chomp
      break if answer.to_i.to_s == answer
      puts 'Thats not valid input'
    end
    answer.to_i
  end

  def display_guesses_remaining
    puts ''
    puts "You have #{guesses} guesses remaining."
  end

  def update_guess_counter
    self.guesses -= 1
  end

  def display_winner
    puts 'Thats the number!'
  end

  def hint(answer)
    if answer > number
      puts 'Your guess is too high!'
    else
      puts 'Your guess is too low!'
    end
  end



  private

  attr_reader :number
end

Game.new.play