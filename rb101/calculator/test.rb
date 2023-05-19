 
def check(n)
  #return true if n.to_i == 0 && n == "0"
    
   
  n.to_i.to_s == n
end

p check("1")
p check("0")
p check("00")
p check("0.0")

p check(".0")
p check("gf")
p check("s")