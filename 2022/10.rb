instructions = File.readlines('10.txt', chomp: true)

current_cycle = 0
x = 1
cycles = []
instructions.each do |instruction|
  if instruction == 'noop'
    cycles[current_cycle] = x
    current_cycle += 1
  else
    cycles[current_cycle] = x
    cycles[current_cycle + 1] = x
    _, val = instruction.split(' ')
    x += val.to_i
    current_cycle += 2
  end
end

i = 20
sum = 0
while cycles[i]
  sum += cycles[i-1] * i
  i += 40
end

p sum

# part 2

6.times do |y|
  40.times do |x|
    val = cycles[y*40 + x]
    print ((val-1)..(val+1)).include?(x) ? '##' : '..'
  end
  puts
end
