def some_method
  yield 
  #'goodbye'
end



p some_method { return 'hello' }