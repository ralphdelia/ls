


def some_method
  value = 0

  [Proc.new{ value += 1 }, Proc.new{ puts value }]
end

increment, counter = some_method

increment.call
increment.call
counter.call

