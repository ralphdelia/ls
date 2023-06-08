def palindrome?(str)
  str == str.reverse
end

def palindrome_2?(collection)
  beginning = 0
  end_of = collection.size - 1
  results = []

  while beginning <= (collection.size / 2)
    results.push(collection[beginning] == collection[end_of])
    beginning += 1
    end_of -= 1
  end

  results.none? { |v| v == false }
end

def palindrome_3?(collection)
  beginning = 0
  end_of = collection.size - 1

  while beginning <= end_of
    return false unless collection[beginning] == collection[end_of]

    beginning += 1
    end_of -= 1
  end

  true
end
