famous_words = "seven years ago..."

puts 'Four score and '.concat(famous_words)
puts 'Four score and ' + famous_words
famous_words.prepend("Four score and ")
"Four score and " << famous_words