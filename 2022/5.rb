input = File.read('5.txt', chomp: true)

# part 1

stack_description, instructions = input.split("\n\n").map { |string| string.split("\n") }

stack_indexes = stack_description.pop

stacks = []
stack_description.reverse.each do |stack|
  1.upto(9) do |i|
    stacks[i-1] = [] unless stacks[i-1]
    char = stack[stack_indexes.index(i.to_s)]
    stacks[i-1] << char if char && !char.strip.empty?
  end
end

instructions.each do |instruction|
  count, from, to = instruction.scan(/\d+/).map(&:to_i)
  count.times do
    stacks[to-1] << stacks[from-1].pop
  end
end

p stacks.map(&:last).join

# part 2

stacks = []
stack_description.reverse.each do |stack|
  1.upto(9) do |i|
    stacks[i-1] = [] unless stacks[i-1]
    char = stack[stack_indexes.index(i.to_s)]
    stacks[i-1] << char if char && !char.strip.empty?
  end
end

instructions.each do |instruction|
  count, from, to = instruction.scan(/\d+/).map(&:to_i)
  moving = stacks[from-1].slice!(-count..-1)
  (stacks[to-1] << moving).flatten!
end

p stacks.map(&:last).join
