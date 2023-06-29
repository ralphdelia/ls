require 'pry'
def joinor(arr, separator = ', ', last_separator = 'or')
  if arr.length <= 2 
    arr.join(" #{last_separator} ")
  else
    last = arr.last
    arr = arr.map do |element|
      if element == last
        "#{last_separator} #{element}"
      else
        "#{element}#{separator}"
      end
    end
    arr.join()
  end
end

def joinor(arr, delimiter=', ', word='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first.to_s
  when 2 then arr.join(" #{word} ")
  else
    arr[-1] = "#{word} #{arr.last}"
    arr.join(delimiter)
  end
end


puts joinor([1, 2]) == "1 or 2"
puts joinor([1, 2, 3]) == "1, 2, or 3"
puts joinor([1, 2, 3], '; ') == "1; 2; or 3"
puts joinor([1, 2, 3], ', ', 'and') == "1, 2, and 3"
