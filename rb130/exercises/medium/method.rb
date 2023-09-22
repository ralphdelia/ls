# Replace the two `method_name` placeholders with actual method calls
def convert_to_base_8(n)
  n.to_s(8).to_i
end

# Replace `argument` with the correct argument below
# `method` is `Object#method`, not a placeholder
base8_proc = method(:convert_to_base_8).to_proc

# We'll need a Proc object to make this code work
# Replace `a_proc` with the correct object
p [8, 10, 12, 14, 16, 33].map(&base8_proc)


=begin
method to proc 
so methods can be turned into procs
passed to methods and turned into a block 

convert_to_base  is method
  turn it into a proc (line 8)
  it takes an argument
    the proc will be called on each element of the array
    so what will the argument be? 
    we want it to be the caller

object.method() 
  takes a symbol argument 
  looks up the method and returns a method object
    the method object acts as a closure 
  we can use .call to call the method 
  we can bind the object to a local variable 


proc.new {|x| something}
method(&proc)
=end
