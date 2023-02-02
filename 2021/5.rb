data = File.readlines('5.txt', chomp: true)
vents = data.map { |line| [:x1, :y1, :x2, :y2].zip(line.split(' -> ').map { |vent| vent.split(',') }.flatten.map(&:to_i)).to_h }

# part 1
grid = Hash.new(0)
vents.each do |vent|
  if vent[:x1] == vent[:x2]
    lesser, greater = vent.slice(:y1, :y2).values.minmax
    lesser.upto(greater) { |y| grid["#{vent[:x1]}:#{y}"] += 1 }
  elsif vent[:y1] == vent[:y2]
    lesser, greater = vent.slice(:x1, :x2).values.minmax
    lesser.upto(greater) { |x| grid["#{x}:#{vent[:y1]}"] += 1 }
  end
end

p grid.count { |k, v| v > 1 }

# part 2

grid = Hash.new(0)
vents.each do |vent|
  x_change = -(vent[:x1] <=> vent[:x2])
  y_change = -(vent[:y1] <=> vent[:y2])
  curr_x = vent[:x1]
  curr_y = vent[:y1]
  while curr_x != vent[:x2] || curr_y != vent[:y2]
    grid["#{curr_x}:#{curr_y}"] += 1
    curr_x += x_change
    curr_y += y_change
  end
  grid["#{curr_x}:#{curr_y}"] += 1
end

p grid.count { |k, v| v > 1 }
