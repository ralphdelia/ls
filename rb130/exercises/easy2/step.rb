def step(count, last, increment_value)
  while count <= last
    yield(count)
    count += increment_value
  end
  count
end


step(1, 10, 3) { |value| puts "value = #{value}" }



