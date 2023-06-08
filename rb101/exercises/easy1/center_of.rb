def center_of(str)
  center = str.size / 2 
  return str[center] if str.size.odd?
  return str[center- 1, 2]
end

puts center_of("asdfdsa")