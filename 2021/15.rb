data = File.readlines('15.txt', chomp: true)

grid = data.map { |line| line.chars.map(&:to_i) }

curr = [0, 0]

# part 1

tentative_distances = { [0,0] => 0 }
unvisited = {}
grid.each_with_index do |line, y|
  line.each_with_index do |cell, x|
    next if x == 0 && y == 0
    tentative_distances[[x, y]] = Float::INFINITY
    unvisited[[x, y]] = true
  end
end

loop do
  x = curr.first
  y = curr.last
  puts "#{x} #{y}"
  -1.upto(1) do |x_diff|
    -1.upto(1) do |y_diff|
      next if x_diff == 0 && y_diff == 0
      next if (x_diff + y_diff).abs != 1
      next unless unvisited[[x+x_diff, y+y_diff]]
      distance_from_current = tentative_distances[[x, y]] + grid[y+y_diff][x+x_diff]
      if distance_from_current < tentative_distances[[x+x_diff, y+y_diff]]
        tentative_distances[[x+x_diff, y+y_diff]] = distance_from_current
      end
    end
  end
  unvisited[[x, y]] = false
  break unless unvisited[[grid[0].length - 1, grid.length - 1]]
  curr = tentative_distances.select { |k, v| unvisited[k] && v < Float::INFINITY }.min { |a, b| a[1] <=> b[1] }[0]
end


p tentative_distances[[grid[0].length - 1, grid.length - 1]]


# part 2
require 'pqueue'

grid = data.map { |line| line.chars.map(&:to_i) }
grid = Array.new(data.length * 5) { Array.new(data[0].length * 5) }

data.each_with_index do |line, y|
  0.upto(4) do |y_mult|
    line.chars.each_with_index do |cell, x|
      0.upto(4) do |x_mult|
        val = x_mult + y_mult + cell.to_i
        val = val - 9 if val > 9
        grid[y_mult*data.size + y][x_mult*line.size + x] = val
      end
    end
  end
end

distances = Hash.new(Float::INFINITY)
distances[[0,0]] = 0
distances_queue = PQueue.new([[[0, 0], 0]]) { |a, b|  a[1] < b[1] }
unvisited = {}
grid.each_with_index do |line, y|
  line.each_with_index do |cell, x|
    next if x == 0 && y == 0
    unvisited[[x, y]] = true
  end
end

max_x = grid[0].length - 1
max_y = grid.length - 1
curr = [[0, 0], 0]

loop do
  x,y  = curr.first
  # puts "#{x} #{y}"
  -1.upto(1) do |x_diff|
    -1.upto(1) do |y_diff|
      next if x_diff == 0 && y_diff == 0
      next if (x_diff + y_diff).abs != 1
      next unless unvisited[[x+x_diff, y+y_diff]]
      distance_from_current = distances[[x, y]] + grid[y+y_diff][x+x_diff]
      if distance_from_current < distances[[x+x_diff, y+y_diff]]
        distances[[x+x_diff, y+y_diff]] = distance_from_current
        distances_queue.push([[x+x_diff, y+y_diff], distance_from_current])
      end
    end
  end
  unvisited[[x, y]] = false
  break unless unvisited[[max_x, max_y]]
  curr = distances_queue.pop
end

p distances[[max_x, max_y]]
