grid = File.readlines("23.txt", chomp: true).map(&:chars)

# part 1
start = [1,0]
goal = [grid.length-2, grid.last.length-1]

curr = start
visited = Hash.new { false }
to_visit = { curr => true }
distances = Hash.new { 0 }

distances[curr] = 0
dirs = %w[> < ^ v]

until to_visit.empty?
  x, y = curr
  dirs.each do |dir|
    new_x, new_y = []
    case dir
    when "^"
      new_x = x
      new_y = y-1
    when "v"
      new_x = x
      new_y = y+1
    when ">"
      new_x = x+1
      new_y = y
    when "<"
      new_x = x-1
      new_y = y
    end
    new_node = [new_x, new_y]
    next if new_y < 0 || new_y > grid.length - 1
    next if new_x < 0 || new_x > grid.first.length - 1
    next if grid[new_y][new_x] == "#"
    next if visited[new_node]
    next if dirs.include?(grid[new_y][new_x]) && grid[new_y][new_x] != dir

    cost = distances[curr] + 1
    if cost > distances[new_node]
      distances[new_node] = cost
    end

    to_visit[new_node] = true
  end
  visited[curr] = true
  to_visit.delete(curr)

  filtered = to_visit.keys.filter do |coords|
    cx, cy = coords
    has_empty_neighbor_hill = false
    dirs.each do |dir|
      empty = case dir
      when ">"
        (cx-1) >= 0 && grid[cy][cx-1] == dir && distances[[cx-1,cy]] == 0
      when "<"
        grid.dig(cy,cx+1) == dir && distances[[cx+1,cy]] == 0
      when "^"
        grid.dig(cy+1,cx) == dir && distances[[cx,cy+1]] == 0
      when "v"
        (cy-1) >= 0 && grid[cy-1][cx] == dir && distances[[cx,cy-1]] == 0
      end
      has_empty_neighbor_hill = empty if empty
    end
    !has_empty_neighbor_hill
  end
  curr = (filtered.empty? ? to_visit.keys : filtered).max { |a, b| distances[a] <=> distances[b] }
end

p distances[goal]

# grid.each_with_index do |line, y|
#   line.each_with_index do |char, x|
#     if distances[[x,y]] != 0
#       print distances[[x,y]].to_s.rjust(2)
#     else
#       print grid[y][x] + grid[y][x]
#     end
#   end
#   puts
# end

# part 2

nodes = Hash.new { |h,k| h[k] = [] }

nodes[[1,0]] = [:s]
nodes[goal] = [:n]

# find all turns and figure out which way (n s e w) they lead
grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next if char == "#"

    neighbors = []

    if y-1 >= 0 && (["."] + dirs).include?(grid.dig(y-1, x))
      neighbors << :n
    end
    if (["."] + dirs).include?(grid.dig(y+1, x))
      neighbors << :s
    end
    if x-1 >= 0 && (["."] + dirs).include?(grid.dig(y, x-1))
      neighbors << :w
    end
    if (["."] + dirs).include?(grid.dig(y, x+1))
      neighbors << :e
    end

    if (neighbors.include?(:n) && (neighbors.include?(:w) || neighbors.include?(:e))) ||
        (neighbors.include?(:s) && (neighbors.include?(:w) || neighbors.include?(:e)))
      nodes[[x,y]] = neighbors
    end
  end
end

# convert all n s e w directions into the coordinates of the next turns in that direction
nodes = nodes.map do |coord, neighbors|
  neighbor_nodes = []
  neighbors.each do |neighbor|
    x,y = coord
    case neighbor
    when :n
      dy = y-1
      dy -= 1 until nodes.has_key?([x,dy])
      neighbor_nodes << [x,dy]
    when :s
      dy = y+1
      dy += 1 until nodes.has_key?([x,dy])
      neighbor_nodes << [x,dy]
    when :w
      dx = x-1
      dx -= 1 until nodes.has_key?([dx,y])
      neighbor_nodes << [dx,y]
    when :e
      dx = x+1
      dx += 1 until nodes.has_key?([dx,y])
      neighbor_nodes << [dx,y]
    end
  end
  [coord, neighbor_nodes]
end.to_h

# reduce nodes from all turns to just intersections and distances between connecting intersections
new_nodes = {}
nodes.select { |coord, neighbors| neighbors.count > 2 || coord == start }.each do |coord, neighbors|
  new_neighbors = {}
  neighbors.each do |neighbor|
    seen = { coord => true }
    distance = (coord[0] - neighbor[0]).abs + (coord[1] - neighbor[1]).abs
    # p neighbor
    curr = neighbor
    until !curr || nodes[curr].length > 2 || curr == goal
      new_coord = nodes[curr].find { |n_coord| !seen[n_coord] }
      seen[curr] = true
      distance += (curr[0] - new_coord[0]).abs + (curr[1] - new_coord[1]).abs if new_coord
      curr = new_coord
    end
    new_neighbors[curr] = distance if curr
  end
  new_nodes[coord] = new_neighbors.compact
end

@goal = goal

def search(curr, visited, distance, nodes)
  return distance if curr == @goal
  visited[curr] = true
  distances = []
  nodes[curr].each do |neighbor, neighbor_distance|
    next if visited[neighbor]
    new_distance = distance + neighbor_distance
    distances << search(neighbor, visited.dup, new_distance, nodes)
  end

  distances.select(&:positive?).empty? ? -1 : distances.max
end

p search([1,0], {}, 0, new_nodes)
