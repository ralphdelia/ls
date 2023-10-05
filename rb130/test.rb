

def some_method
  p x
end

x = 10
a_proc = method(:some_method).to_proc


def another_method(proc)
  proc.call 
end


another_method(a_proc)