arr = %w(a b c)

arr.each do |ele|
  puts ele.object_id
end



a = arr.map do |ele|
  ele
end

a.each do |ele|
  puts ele.object_id
end

arr.each do |ele|
  puts ele.object_id
end
