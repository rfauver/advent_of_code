require 'pry'

class Intcode
  def initialize(program)
    @memory = program
    @point = 0
    @relative_base = 0
    @last_output = nil
  end

  def run
    loop do
      set_pointer = false
      opcode, modes = read_instruction
      # puts "opcode: #{opcode.inspect}"
      # puts "modes: #{modes.inspect}"
      # puts "point: #{@point.inspect}"
      # puts @memory.inspect
      param_count = case opcode
                    when 1..2, 7..8 then 3
                    when 3..4, 9 then 1
                    when 5..6 then 2
                    else 0
                    end
      params = get_params(modes, param_count)
      # puts "params: #{params.inspect}"
      output_address = value_at(@point + param_count)
      output_address += @relative_base if modes[param_count - 1] == 2
      case opcode
      when 1
        @memory[output_address] = params[0] + params[1]
      when 2
        @memory[output_address] = params[0] * params[1]
      when 3
        @memory[output_address] = yield
      when 4
        @last_output = params[0]
        @point += (param_count + 1)
        # puts({ output: @last_output, status: :running })
        return { output: @last_output, status: :running }
      when 5
        @point = params[1] if (set_pointer = !params[0].zero?)
      when 6
        @point = params[1] if (set_pointer = params[0].zero?)
      when 7
        @memory[output_address] = params[0] < params [1] ? 1 : 0
      when 8
        @memory[output_address] = params[0] == params [1] ? 1 : 0
      when 9
        @relative_base += params[0]
      when 99
        puts 'HALT'
        return { output: @last_output, status: :halted }
      else
        puts "UNKNOWN OPCODE #{opcode}"
        return
      end
      @point += (param_count + 1) unless set_pointer
    end
  end

  def value_at(address)
    @memory[address] || 0
  end

  def read_at(address)
    @memory[@memory[address] || 0] || 0
  end

  def read_instruction
    instruction = value_at(@point).to_s.chars
    opcode = instruction.pop(2).join.to_i
    modes = instruction.reverse.map(&:to_i)
    [opcode, modes]
  end

  def get_params(modes, param_count)
    param_count.times.map do |i|
      case modes[i]
      when nil, 0
        read_at(@point + i + 1)
      when 1
        value_at(@point + i + 1)
      when 2
        value_at(@relative_base + value_at(@point + i + 1))
      end
    end
  end
end

program = [3,8,1005,8,330,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,28,1,1103,17,10,1006,0,99,1006,0,91,1,102,7,10,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,1002,8,1,64,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,86,2,4,0,10,1006,0,62,2,1106,13,10,3,8,1002,8,-1,10,1001,10,1,10,4,10,1008,8,0,10,4,10,101,0,8,120,1,1109,1,10,1,105,5,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,149,1,108,7,10,1006,0,40,1,6,0,10,2,8,9,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,1002,8,1,187,1,1105,10,10,3,8,102,-1,8,10,1001,10,1,10,4,10,1008,8,1,10,4,10,1002,8,1,213,1006,0,65,1006,0,89,1,1003,14,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,102,1,8,244,2,1106,14,10,1006,0,13,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,273,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1001,8,0,295,1,104,4,10,2,108,20,10,1006,0,94,1006,0,9,101,1,9,9,1007,9,998,10,1005,10,15,99,109,652,104,0,104,1,21102,937268450196,1,1,21102,1,347,0,1106,0,451,21101,387512636308,0,1,21102,358,1,0,1105,1,451,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,0,97751428099,1,21102,1,405,0,1105,1,451,21102,1,179355806811,1,21101,416,0,0,1106,0,451,3,10,104,0,104,0,3,10,104,0,104,0,21102,1,868389643008,1,21102,439,1,0,1105,1,451,21102,1,709475853160,1,21102,450,1,0,1105,1,451,99,109,2,22102,1,-1,1,21101,0,40,2,21101,482,0,3,21102,1,472,0,1105,1,515,109,-2,2106,0,0,0,1,0,0,1,109,2,3,10,204,-1,1001,477,478,493,4,0,1001,477,1,477,108,4,477,10,1006,10,509,1101,0,0,477,109,-2,2105,1,0,0,109,4,2101,0,-1,514,1207,-3,0,10,1006,10,532,21101,0,0,-3,21202,-3,1,1,22101,0,-2,2,21101,1,0,3,21101,0,551,0,1105,1,556,109,-4,2106,0,0,109,5,1207,-3,1,10,1006,10,579,2207,-4,-2,10,1006,10,579,22102,1,-4,-4,1105,1,647,21201,-4,0,1,21201,-3,-1,2,21202,-2,2,3,21101,0,598,0,1106,0,556,22101,0,1,-4,21102,1,1,-1,2207,-4,-2,10,1006,10,617,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,639,22102,1,-1,1,21102,1,639,0,105,1,514,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0];

# part 1
# dir = 0
# x = 0
# y = 0
# visited = {}
# comp = Intcode.new(program)

# loop do
#   # binding.pry
#   result = comp.run { visited[[x,y]] || 0 }
#   break if result[:status] == :halted
#   color = result[:output]
#   result = comp.run { visited[[x,y]] || 0 }
#   break if result[:status] == :halted
#   turn = result[:output]
#   visited[[x, y]] = color
#   case turn
#   when 0
#     dir = (dir - 1) % 4
#   when 1
#     dir = (dir + 1) % 4
#   end
#   case dir
#   when 0
#     y -= 1
#   when 1
#     x += 1
#   when 2
#     y += 1
#   when 3
#     x -= 1
#   end
# end
# puts visited.length

# part 2

dir = 0
x = 0
y = 0
visited = {[0,0] => 1}
comp = Intcode.new(program)

loop do
  # binding.pry
  result = comp.run { visited[[x,y]] || 0 }
  break if result[:status] == :halted
  color = result[:output]
  result = comp.run { visited[[x,y]] || 0 }
  break if result[:status] == :halted
  turn = result[:output]
  visited[[x, y]] = color
  case turn
  when 0
    dir = (dir - 1) % 4
  when 1
    dir = (dir + 1) % 4
  end
  case dir
  when 0
    y -= 1
  when 1
    x += 1
  when 2
    y += 1
  when 3
    x -= 1
  end
end

grid = Array.new(6) { Array.new(50) { '.' } }
visited.each do |(x, y), color|
  grid[y][x] = 'X' if color == 1
end
grid.each do |row|
  row.each do |char|
    print char
  end
  puts
end

