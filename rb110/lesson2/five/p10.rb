

arr = [{a: 1}, {b: 2, c: 3}, {d: 4, e: 5, f: 6}]


x = arr.map do |hash|
  other_hash = {}
  hash.each do |k, v|
    other_hash[k] = v + 1
  end
  other_hash
end
p x