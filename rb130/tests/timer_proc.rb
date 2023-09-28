def timer
  start = Time.new

  Proc.new {Time.new - start}
end

time_passed = timer()


loop do 
  puts "Enter 'y' to see how much time has passed since this program started"
  puts "Enter 'n' to exit"

  answer = gets.chomp.downcase

  break if answer == 'n'
  puts time_passed.call
end
