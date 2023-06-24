words = "the flintstones rock"


def titleize(string)
  string.split(' ').map {|ele| ele.capitalize }.join(' ')
end


p titleize(words)