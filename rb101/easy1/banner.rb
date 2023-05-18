def print_in_box(string)
  top_bottom = ["+", "-", "-", "+"]
  mid = ["|", " ", " ", "|"]
  center = "| " + string + " |"
  length = string.size
  
  length.times{ top_bottom.insert(2, "-") }
  length.times{ mid.insert(2, " ")}


  puts top_bottom.join
  puts mid.join
  puts center
  puts mid.join
  puts top_bottom.join
end





print_in_box('To boldly go where no one has gone before.')
