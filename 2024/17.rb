data = File.read('17.txt', chomp: true)

# part 1

registers, program = data.split("\n\n")

a, b, c = registers.split("\n").map { |r| r[12..-1].to_i }
program = program.scan(/\d/).map(&:to_i)
instruction_pointer = 0
output = []

loop do
  opcode = program[instruction_pointer]
  operand = program[instruction_pointer + 1]
  break if opcode.nil? || operand.nil?
  combo_value = if (0..3).include?(operand)
    operand
  elsif operand == 4
    a
  elsif operand == 5
    b
  elsif operand == 6
    c
  elsif operand == 7
    raise 'invalid program'
  end

  case opcode
  when 0
    a = a / (2 ** combo_value)
  when 1
    b = b ^ operand
  when 2
    b = combo_value % 8
  when 3
    if a != 0
      instruction_pointer = operand
      next
    end
  when 4
    b = b ^ c
  when 5
    output << combo_value % 8
  when 6
    b = a / (2 ** combo_value)
  when 7
    c = a / (2 ** combo_value)
  end
  instruction_pointer += 2
end

puts output.join(",")

# part 2

# my program implemented into a function
def func(a)
  output = []
  loop do
    b = (((a % 8) ^ 1) ^ 5) ^ (a / (2 ** ((a % 8) ^ 1)))
    output << b % 8
    a = a / 8
    break if a == 0
  end
  output
end

@program = program
@a_values = []

def search(digit)
  if digit.to_s(8).length == @program.length
    @a_values << digit
    return
  end
  0.upto(7) do |x|
    check = (digit * 8) + x
    output = func(check)
    if (output.reverse == @program.reverse[0..(check.to_s(8).length-1)])
      search(check)
    end
  end
end

search(0)
p @a_values.min
