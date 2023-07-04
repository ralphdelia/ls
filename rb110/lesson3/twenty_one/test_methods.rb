
def calculate_ace_combinations(number)
  values = [1, 11]
  combinations = []
  values.repeated_combination(number) do |combination|
    combinations.push(combination)
  end
  sums = combinations.map { |arr| arr.reduce(:+) }
  sums.sort { |a, b| b <=> a }
end

def initialize_ace_index(hash)
  [1, 2, 3, 4].each do |element|
    hash[element] = calculate_ace_combinations(element)
  end
end
hash = {}
 initialize_ace_index(hash)
p hash
=begin
def start_screen
  system 'clear'
  lines = [
    "┌─────────┐┌─────────┐",
    "│2        ││1        │",
    "│         ││         │",
    "│         ││         │",
    "│    ♥    ││    ♥    │",
    "│         ││         │",
    "│         ││         │",
    "│        2││        1│",
    "└─────────┘└─────────┘",
    " Welcome to Twenty-One"
  ]
  lines.each do |line|
    puts line.center(42)
  end

  str = ''
  12.times do
    str << "--"
    system 'clear'
    lines.each do |line|
      puts line.center(42)
    end
    puts str.center(42)
    sleep(0.1)
  end

  12.times do
    str.slice!(-2, 2)
    system 'clear'
    lines.each do |line|
      puts line.center(42)
    end
    puts str.center(42)
    sleep(0.1)
  end
end

start_screen
=end
puts '-' * 42
