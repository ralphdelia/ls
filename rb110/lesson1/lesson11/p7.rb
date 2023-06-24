statement = "The Flintstones Rock"


hash = {}

statement.chars.each do |ele|
  if hash.key?(ele)
    hash[ele] += 1
  else 
    hash[ele] = 1
  end
end

p hash