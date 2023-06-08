


def palindrome?(str)
  str == str.reverse
end

def real_palindrome?(string)
  punctuation_and_space = ['"', "'",  '.', ',', " "]
  non_punctuated_string =""
  string.each_char do |char|
    non_punctuated_string << char unless punctuation_and_space.include?(char)
  end
  palindrome?(non_punctuated_string.downcase)
end


puts real_palindrome?('madam') == true
puts real_palindrome?('Madam') == true           # (case does not matter)
puts real_palindrome?("Madam, I'm Adam")  # (only alphanumerics matter)
puts real_palindrome?('356653') == true
puts real_palindrome?('356a653') == true
puts real_palindrome?('123ab321') == false














