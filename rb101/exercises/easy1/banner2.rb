#assumes that the text length will be longer than 80
def add_segments(string, length)
  segments = []
  current_segment = ""

  string.each_char do |char|
    current_segment += char 
    if current_segment.length == length
      segments << current_segment
      current_segment = ""
    end
  end
  
  if current_segment.size <= 76 
    remainder = 76 - current_segment.size 
    current_segment = current_segment + "#{" " * remainder}"
  end

  segments << current_segment 
  segments 
end 

def banner(string)
  puts "+#{'-' * 78}+"
  puts "|#{' ' * 78}|"
  
  add_segments(string, 76).each do |element|
    puts "| " + element + " |"
  end

  puts "|#{' ' * 78}|"
  puts "+#{'-' * 78}+"
end

puts banner("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
