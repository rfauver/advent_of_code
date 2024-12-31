require 'pairing_heap'

lines = File.readlines("18.txt", chomp: true).map { |line| line.split(',').map(&:to_i) }

# part 1

grid = {}

lines[0..1023].each do |pair|
  grid[pair] = true
end

start = [0,0]

grid_width = 70
grid_height = 70

queue = []
distances = {}

0.upto(grid_height) do |y|
  0.upto(grid_width) do |x|
    next if grid[[x,y]]
    queue << [x,y]
    distances[[x,y]] = Float::INFINITY
  end
end

distances[start] = 0

until queue.empty?
  queue.sort_by! { |pair| distances[pair] }
  curr = queue.shift

  break if curr == [grid_width, grid_height]

  x,y = curr
  neighbors = []
  -1.upto(1) do |dx|
    -1.upto(1) do |dy|
      next if (dx + dy).abs != 1
      next if x+dx < 0 || x+dx > grid_width || y+dy < 0 || y+dy > grid_height
      neighbors << [x + dx, y + dy] unless grid[[x + dx, y + dy]]
    end
  end

  neighbors.each do |neighbor|
    new_dist = distances[curr] + 1
    if new_dist < distances[neighbor]
      distances[neighbor] = new_dist
    end
  end
end

p distances[[70,70]]

# part 2

def path_exists?(grid)
  queue = PairingHeap::MinPriorityQueue.new
  start = [0,0]

  grid_width = 70
  grid_height = 70
  distances = {}

  0.upto(grid_height) do |y|
    0.upto(grid_width) do |x|
      next if grid[[x,y]]
      queue.push([x,y], Float::INFINITY)
      distances[[x,y]] = Float::INFINITY
    end
  end
  distances[start] = 0

  until queue.empty?
    curr = queue.pop
    # p distances[curr] if curr == [grid_width, grid_height]
    return distances[curr] != Float::INFINITY if curr == [grid_width, grid_height]

    x,y = curr
    neighbors = []
    -1.upto(1) do |dx|
      -1.upto(1) do |dy|
        next if (dx + dy).abs != 1
        next if x+dx < 0 || x+dx > grid_width || y+dy < 0 || y+dy > grid_height
        neighbors << [x + dx, y + dy] unless grid[[x + dx, y + dy]]
      end
    end

    neighbors.each do |neighbor|
      new_dist = distances[curr] + 1
      if new_dist < distances[neighbor]
        distances[neighbor] = new_dist
        queue.decrease_key(neighbor, new_dist)
      end
    end
  end

  # p distances[[70,70]]
  return distances[[grid_width, grid_height]] != Float::INFINITY
end


path_exists?(grid)

1023.upto(lines.length - 1) do |i|
  # p i
  grid[lines[i]] = true
  unless path_exists?(grid)
    p lines[i].join(",")
    break
  end
end
