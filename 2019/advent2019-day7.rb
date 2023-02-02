require 'pry'

class Intcode
  def initialize(program, phase)
    @memory = program
    @phase = phase
    @phase_used = false
    @point = 0
    @last_output = nil
  end

  def run(input)
    loop do
      set_pointer = false
      opcode, modes = read_instruction
      # puts "opcode: #{opcode.inspect}"
      # puts "modes: #{modes.inspect}"
      # puts "point: #{@point.inspect}"
      # puts @memory.inspect
      param_count = case opcode
                    when 1..2, 7..8 then 3
                    when 3..4 then 1
                    when 5..6 then 2
                    else 0
                    end
      params = get_params(modes, param_count)
      # puts "params: #{params.inspect}"
      case opcode
      when 1
        @memory[value_at(@point + 3)] = params[0] + params[1]
      when 2
        @memory[value_at(@point + 3)] = params[0] * params[1]
      when 3
        @memory[value_at(@point + 1)] = @phase_used ? input : @phase
        @phase_used ||= true
      when 4
        @last_output = params[0]
        @point += (param_count + 1)
        break { output: @last_output, status: :running }
      when 5
        @point = params[1] if (set_pointer = !params[0].zero?)
      when 6
        @point = params[1] if (set_pointer = params[0].zero?)
      when 7
        @memory[value_at(@point + 3)] = params[0] < params [1] ? 1 : 0
      when 8
        @memory[value_at(@point + 3)] = params[0] == params [1] ? 1 : 0
      when 99
        # puts 'HALT'
        break { output: @last_output, status: :halted }
      else
        puts 'UNKNOWN OPCODE'
        break
      end
      @point += (param_count + 1) unless set_pointer
    end
  end

  def value_at(address)
    @memory[address]
  end

  def read_at(address)
    @memory[@memory[address]]
  end

  def read_instruction
    instruction = value_at(@point).to_s.chars
    opcode = instruction.pop(2).join.to_i
    modes = instruction.reverse.map(&:to_i)
    [opcode, modes]
  end

  def get_params(modes, param_count)
    param_count.times.map do |i|
      send((modes[i]&.positive? ? :value_at : :read_at), @point + i + 1)
    end
  end
end


program = [3,8,1001,8,10,8,105,1,0,0,21,42,67,84,109,126,207,288,369,450,99999,3,9,102,4,9,9,1001,9,4,9,102,2,9,9,101,2,9,9,4,9,99,3,9,1001,9,5,9,1002,9,5,9,1001,9,5,9,1002,9,5,9,101,5,9,9,4,9,99,3,9,101,5,9,9,1002,9,3,9,1001,9,2,9,4,9,99,3,9,1001,9,2,9,102,4,9,9,101,2,9,9,102,4,9,9,1001,9,2,9,4,9,99,3,9,102,2,9,9,101,5,9,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,99]

# Part 1
# max_thrust = 0

# [0, 1, 2, 3, 4].permutation do |perm|
#   input = 0
#   thrust = perm.map do |phase|
#     input = Intcode.new(program, phase).run(input)[:output]
#   end.max
#   max_thrust = thrust if thrust > max_thrust
# end
# puts "max_thrust: #{max_thrust}"


# Part 2
max_thrust = 0

[5, 6, 7, 8, 9].permutation do |perm|
  input = 0
  comps = perm.map do |phase|
    Intcode.new(program, phase)
  end
  results = []
  thrust = comps.cycle.with_index do |comp, i|
    result = comp.run(input)
    results[i % comps.length] = result
    break result[:output] if results.all? { |res| res[:status] == :halted }
    input = result[:output]
    # puts results.inspect
  end
  max_thrust = thrust if thrust > max_thrust
end
puts "max_thrust: #{max_thrust}"
