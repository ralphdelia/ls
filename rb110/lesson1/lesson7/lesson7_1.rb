produce = {
  'apple' => 'Fruit',
  'carrot' => 'Vegetable',
  'pear' => 'Fruit',
  'broccoli' => 'Vegetable'
}

def select_fruit(hash)
  selected = {}
  counter = 0

  hash_keys = hash.keys
  loop do 
  break if counter >= hash_keys.size
  
  current_key = hash_keys[counter]

  if hash[current_key] == "Fruit"
    selected[current_key] = "Fruit"
  end

  counter += 1
  end
  selected
end



p select_fruit(produce) # => {"apple"=>"Fruit", "pear"=>"Fruit"}