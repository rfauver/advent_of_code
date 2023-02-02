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
