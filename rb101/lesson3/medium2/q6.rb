def color_valid(color)
  if color == "blue" || color == "green"
    true
  else
    false
  end
end




def color_valid(color)
  return true if color == "blue" || color == "green"
  false 
end

def color_valid(color)
  color == "blue" || color == "green"
end