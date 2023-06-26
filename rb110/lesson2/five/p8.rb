hsh = {first: ['the', 'quick'], second: ['brown', 'fox'], third: ['jumped'], fourth: ['over', 'the', 'lazy', 'dog']}


#output all the values from the string
#input hash with keys that reference arrays 

# [[stirng , string ] [string, string ]]
#iterate over all the arrays 
#iterate over all  the strings in the arrays
#select the vowels and output them 


hsh.values.each do |element|
  element.each do |string|
    string.chars.each do |letter|
      puts letter if 'aeiou'.include?(letter)
    end
  end
end
