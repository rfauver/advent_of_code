grid = File.readlines("06.txt", chomp: true).map(&:chars)

# part 1

start_curr = nil

grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    if char == "^"
      start_curr = [x, y]
      break;
    end
  end
  break unless start_curr.nil?
end
@dir_to_the_right = { e: :s, s: :w, w: :n, n: :e }

# part 1

def next_node(curr, dir)
  case dir
  when :n
    [curr.first, curr.last - 1]
  when :s
    [curr.first, curr.last + 1]
  when :e
    [curr.first + 1, curr.last]
  when :w
    [curr.first - 1, curr.last]
  end
end


curr = start_curr
dir = :n
visited = {}

while !curr.nil? && curr.first >= 0 && curr.first < grid.first.length && curr.last >= 0 && curr.last < grid.length
  visited[curr] = true
  node = next_node(curr, dir)
  if node.all? { |coord| coord >= 0 } && grid.dig(node.last, node.first) == "#"
    dir = @dir_to_the_right[dir]
  else
    curr = node
  end
end

p visited.count

# part 2

def path_overlaps(curr, dir, grid)
  found = false
  visited = {}
  while !curr.nil? && curr.first >= 0 && curr.first < grid.first.length && curr.last >= 0 && curr.last < grid.length
    visited[curr + [dir]] = true
    node = next_node(curr, dir)
    if node.all? { |coord| coord >= 0 } && grid.dig(node.last, node.first) == "#"
      dir = @dir_to_the_right[dir]
    else
      curr = node
    end

    found = visited[curr + [dir]]
    break if found
  end
  found
end

def grid_with_new_wall(node, grid)
  grid.map.with_index do |line, y|
    line.map.with_index do |char, x|
      node == [x, y] ? "#" : char
    end
  end
end

curr = start_curr
dir = :n
added_walls = {}
visited = {}

while !curr.nil? && curr.first >= 0 && curr.first < grid.first.length && curr.last >= 0 && curr.last < grid.length
  visited[curr] = true
  node = next_node(curr, dir)
  next_is_wall = node.all? { |coord| coord >= 0 } && grid.dig(node.last, node.first) == "#"
  found = !visited[node] && !next_is_wall && path_overlaps(curr.dup, @dir_to_the_right[dir], grid_with_new_wall(node, grid))
  added_walls[node] = true if found

  if next_is_wall
    dir = @dir_to_the_right[dir]
  else
    curr = node
  end
end

p added_walls.count
