
score = {player: 0, computer: 0}
def update_match(score)
  score[:player] += 1
end

def display_match(score)
  puts "You have #{score[:player]} points, the computer has #{score[:computer]} points."
end
p score

update_match(score)
update_match(score)
update_match(score)

p score
p winner = score.select { |k, v| v >= 3 }

puts winner.keys[0]



display_match(score)
