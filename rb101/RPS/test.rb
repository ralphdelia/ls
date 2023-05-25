win_index = {'lizard' => ['spock', 'paper'], 
              'spock' => ['rock', 'scissors'],
              'rock' => ['lizard', 'scissors'],
              'paper' => ['spock', 'rock'],
              'scissors' => ['lizard', 'paper']
            }

def win?(first, second, win_index)
  first_defeats = win_index[first]
  first_defeats.include?(second)
end

puts win?('lizard', 'rock', win_index)