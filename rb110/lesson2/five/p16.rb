

def uuid
  characters_and_numbers = ('a'..'z').to_a + ('0'..'9').to_a
  uuid_format = [8, 4, 4, 4, 12]
  result = []
  
  uuid_format.each do |num|
    section = characters_and_numbers.sample(num).join
    result.push(section)
  end
  
  result.join("-")
end


p uuid()
