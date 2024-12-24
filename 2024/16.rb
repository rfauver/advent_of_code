require 'pairing_heap'

grid = File.readlines("16.txt", chomp: true).map(&:chars)

start, endd = nil
grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    start = [x, y] if char == "S"
    endd = [x, y] if char == "E"
  end
end

# part 1

def find_min_costs(start, endd, dir, grid)
  queue = PairingHeap::MinPriorityQueue.new
  grid.each_with_index do |line, y|
    line.each_with_index do |char, x|
      # start = [x, y] if char == "S"
      # endd = [x, y] if char == "E"

      -1.upto(1) do |dx|
        -1.upto(1) do |dy|
          next if (dx + dy).abs != 1
          queue.push({ x: x, y: y, dir: [dx, dy] }, Float::INFINITY)
        end
      end
    end
  end

  start = { x: start[0], y: start[1], dir: dir }
  queue.decrease_key(start, 0)

  costs = Hash.new { |k,v| k[v] = Float::INFINITY }
  costs[start] = 0

  until queue.empty?
    curr = queue.pop
    break if curr[:x] == endd[0] && curr[:y] == endd[1]

    neighbors = []
    -1.upto(1) do |dx|
      -1.upto(1) do |dy|
        next if (dx + dy).abs != 1
        next if (curr[:dir][0] - dx).abs == 2 || (curr[:dir][1] - dy).abs == 2
        neighbor = { x: curr[:x] + dx, y: curr[:y] + dy, dir: [dx, dy]}
        neighbors << neighbor if grid.dig(neighbor[:y], neighbor[:x]) != "#" && queue.include?(neighbor)
      end
    end

    neighbors.each do |neighbor|
      current_costs = costs[curr]
      cost = current_costs + (neighbor[:dir][0] == curr[:dir][0] && neighbor[:dir][1] == curr[:dir][1] ? 1 : 1001)
      if cost < costs[neighbor]
        costs[neighbor] = cost
        queue.decrease_key(neighbor, cost)
      end
    end
  end

  costs
end

costs = find_min_costs(start, endd, [1,0], grid)

min = costs.filter { |k,v| k[:x] == endd[0] && k[:y] == endd[1] }.values.min
p min

# part 2

backwards_costs = []
-1.upto(1) do |dx|
  -1.upto(1) do |dy|
    next if (dx + dy).abs != 1
    backwards_costs << find_min_costs(endd, start, [dx, dy], grid)
  end
end

on_path = {}
grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next if char == "#"
    min_from_start = costs.filter { |k,v| k[:x] == x && k[:y] == y }.values.min
    mins_from_end = backwards_costs.map { |bc| bc.filter { |k,v| k[:x] == x && k[:y] == y }.values.min }.compact
    # p min_from_start
    next if min_from_start.nil?
    next if mins_from_end.length == 0
    on_path[[x,y]] = true if mins_from_end.any? { |min_from_end| min_from_start + min_from_end == min }
  end
end

on_path = on_path.filter do |k,v|
  has_neighbor = false
  -1.upto(1) do |dx|
    -1.upto(1) do |dy|
      next if (dx + dy).abs != 1
      break if has_neighbor
      has_neighbor = on_path[[k[0] + dx, k[1] + dy]]
    end
    break if has_neighbor
  end
  has_neighbor
end.to_h

p on_path.count # off by 2 for some reason...

# grid.each_with_index do |line, y|
#   line.each_with_index do |char, x|
#     if on_path[[x,y]]
#       print "O"
#     else
#       print char
#     end
#   end
#   puts
# end
