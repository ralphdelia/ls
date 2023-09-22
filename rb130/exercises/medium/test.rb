
arr = [10, 12, 14, 16, 20, 41]

def some_method(x)
  puts x
end


a_proc = method(:some_method).to_proc

arr.each(&a_proc)