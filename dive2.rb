Command = Struct.new(:command, :count)

class Submarine
  attr_reader :horizontal_position
  attr_reader :depth
  attr_reader :aim
  
  def initialize
    @horizontal_position = 0
    @depth = 0
    @aim = 0
  end
  
  def accept(command)
    case command.command
    when :forward
      @horizontal_position += command.count
      @depth += @aim * command.count
    when :up
      @aim -= command.count
    when :down
      @aim += command.count
    end
  end
end

def get_commands(filename)
  IO.readlines(filename).map {|s|
    tokens = s.split()
    Command.new(tokens[0].to_sym, tokens[1].to_i)
  }
end

if __FILE__ == $0
  commands = get_commands("dive_commands.txt")
  sub = Submarine.new
  commands.each {|command| sub.accept(command) }
  puts "Horizontal Position: #{sub.horizontal_position}"
  puts "Depth: #{sub.depth}"
  puts "Answer: #{sub.horizontal_position * sub.depth}"
end