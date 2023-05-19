def tri(n)
  empty_space = n - 1

  n.times do
    string = ''
    for i in 1..empty_space
      string = string + " "
    end
    empty_space -= 1

    while string.length < n
      string += "*"
    end

    puts string
  end
end

tri(5)