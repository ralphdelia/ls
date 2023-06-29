arr = [{a: [1, 2, 3]}, 
       {b: [2, 4, 6], c: [3, 6], d: [4]}, 
       {e: [8], f: [6, 10]}]


#inputs 
# an array
  # hashes with arrays as the values

#output
# an array of hashes 

# selection of hashes where all the integers are even 

# Iterate over the elements in the array    
#         The hashes
#Select the hashes  block varaibles are k, v
# return the hashes that meet selection criteria 
# if all the elements within the hash are even

arr = arr.select do |hash|
  hash.all? do |k, v|
    v.all? do |element| 
      element.even?
    end
  end
end

p arr
