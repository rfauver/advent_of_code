require 'pairing_heap'

grid = File.readlines("20.txt", chomp: true).map(&:chars)

@start, @goal = nil

grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    @start = [x,y] if char == "S"
    @goal = [x,y] if char == "E"
  end
end

def shortest_path(grid)
  queue = PairingHeap::MinPriorityQueue.new

  distances = {}

  grid.each_with_index do |line, y|
    line.each_with_index do |char, x|
      next if char == "#"
      queue.push([x,y], Float::INFINITY)
      distances[[x,y]] = Float::INFINITY
    end
  end
  distances[@start] = 0
  queue.decrease_key(@start, 0)

  until queue.empty?
    curr = queue.pop
    return distances[curr] if curr == @goal

    x,y = curr
    neighbors = []
    -1.upto(1) do |dx|
      -1.upto(1) do |dy|
        next if (dx + dy).abs != 1
        next if x+dx < 0 || x+dx > grid.first.length || y+dy < 0 || y+dy > grid.length
        next if grid.dig(y+dy, x+dx) == "#"
        neighbors << [x + dx, y + dy]
      end
    end

    neighbors.each do |neighbor|
      new_dist = distances[curr] + 1
      if new_dist < distances[neighbor]
        distances[neighbor] = new_dist
        if queue.include?(neighbor)
          queue.decrease_key(neighbor, new_dist)
        else
          queue.push(neighbor, new_dist)
        end
      end
    end
  end

  return distances[@goal]
end

normal_length = shortest_path(grid)

distances = []
grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next if x == 0 || y == 0 || x == grid.first.length - 1 || y == grid.length - 1
    next if grid.dig(y, x) != "#"
    new_grid = grid.map(&:dup)
    new_grid.each_with_index do |new_line, new_y|
      new_line.each_with_index do |_, new_x|
        if [new_x, new_y] == [x,y]
          new_grid[new_y][new_x] = "."
        end
      end
    end
    distances << shortest_path(new_grid)
  end
end

differences = distances.map { |dist| normal_length - dist }

p differences.count { |diff| diff >= 100 }

# part 2

def get_distances(grid)
  queue = PairingHeap::MinPriorityQueue.new

  distances = {}

  grid.each_with_index do |line, y|
    line.each_with_index do |char, x|
      next if char == "#"
      queue.push([x,y], Float::INFINITY)
      distances[[x,y]] = Float::INFINITY
    end
  end
  distances[@start] = 0
  queue.decrease_key(@start, 0)

  until queue.empty?
    curr = queue.pop

    x,y = curr
    neighbors = []
    -1.upto(1) do |dx|
      -1.upto(1) do |dy|
        next if (dx + dy).abs != 1
        next if x+dx < 0 || x+dx > grid.first.length || y+dy < 0 || y+dy > grid.length
        next if grid.dig(y+dy, x+dx) == "#"
        neighbors << [x + dx, y + dy]
      end
    end

    neighbors.each do |neighbor|
      new_dist = distances[curr] + 1
      if new_dist < distances[neighbor]
        distances[neighbor] = new_dist
        if queue.include?(neighbor)
          queue.decrease_key(neighbor, new_dist)
        else
          queue.push(neighbor, new_dist)
        end
      end
    end
  end

  return distances
end

distances = get_distances(grid)
count = 0

grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next if char == "#"
    -20.upto(20) do |dx|
      -20.upto(20) do |dy|
        next if dx.abs + dy.abs > 20
        next if x+dx <= 0 || y+dy <= 0 || x+dx >= grid.first.length - 1 || y+dy >= grid.length - 1
        next if grid.dig(y+dy, x+dx) == "#"
        next unless (distances[[x+dx, y+dy]] - distances[[x,y]] - dx.abs - dy.abs) >= 100
        count += 1
      end
    end
  end
end

p count
