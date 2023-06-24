flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]


flintstones_hash = {}
flintstones.each_with_index do |ele, index|
  flintstones_hash[ele] = index
end
p flintstones_hash