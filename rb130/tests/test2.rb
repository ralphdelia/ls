class CommandInvoker
  def initialize
    @commands = []
  end

  def add_command(command)
    @commands << command
  end

  def execute_commands(value)
    @commands.each { |command| value = command.call(value) }
    value  # Return the final result
  end
end

# Create some Procs representing commands
command1 = Proc.new { |var| var + 1 }
command2 = Proc.new { |var| var + 2 }
command3 = Proc.new { |var| var + 3 }

# Create an invoker and add the commands
invoker = CommandInvoker.new
invoker.add_command(command1)
invoker.add_command(command2)
invoker.add_command(command3)

# Execute all the commands
result = invoker.execute_commands(2)
puts result
