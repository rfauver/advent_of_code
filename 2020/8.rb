instructions = File.read('/Users/rfauver/Desktop/data8.txt').split("\n");

accumulator = 0
pointer = 0
seen = {}

loop do
  break accumulator if seen[pointer]
  inst = instructions[pointer]
  seen[pointer] = true
  case inst[0..2]
  when 'acc'
    accumulator += inst[3..-1].to_i
    pointer += 1
  when 'jmp'
    pointer += inst[3..-1].to_i
  else
    pointer += 1
  end
end


# part 2
instructions = File.read('/Users/rfauver/Desktop/data8.txt').split("\n");

def find_total(instructions)
  accumulator = 0
  pointer = 0
  seen = {}

  loop do
    return false if seen[pointer]
    return accumulator if pointer == instructions.length
    inst = instructions[pointer]
    seen[pointer] = true
    case inst[0..2]
    when 'acc'
      accumulator += inst[3..-1].to_i
      pointer += 1
    when 'jmp'
      pointer += inst[3..-1].to_i
    else
      pointer += 1
    end
  end
end



instructions.each_with_index do |inst, i|
  swapped_inst = nil
  case inst[0..2]
  when 'nop'
    swapped_inst = 'jmp'
  when 'jmp'
    swapped_inst = 'nop'
  end
  if swapped_inst
    total = find_total(instructions[0...i] + ["#{swapped_inst} #{inst[3..-1].to_i}"] + instructions[(i+1)..-1])
    break total if total
  end
end
