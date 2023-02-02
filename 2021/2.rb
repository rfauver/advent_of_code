data = File.readlines('2.txt', chomp: true).map { |line| line.split }

# part 1

depth = 0
distance = 0

data.each do |dir, val|
  case dir
  when 'forward'
    distance += val.to_i
  when 'up'
    depth -= val.to_i
  when 'down'
    depth += val.to_i
  end
end

puts depth * distance


# part 2

depth = 0
distance = 0
aim = 0

data.each do |dir, val|
  case dir
  when 'forward'
    distance += val.to_i
    depth += val.to_i * aim
  when 'up'
    aim -= val.to_i
  when 'down'
    aim += val.to_i
  end
end

puts depth * distance
