grid = File.readlines('12.txt', chomp: true).map { |row| row.chars.map(&:codepoints).map(&:first) }

# part 1

start, goal = nil
grid.each_with_index do |row, y|
  row.each_with_index do |square, x|
    start = [x,y] if square == 'S'.codepoints.first
    goal = [x,y] if square == 'E'.codepoints.first
  end
end

grid[start[1]][start[0]] = 'a'.codepoints.first
grid[goal[1]][goal[0]] = 'z'.codepoints.first

set = []
grid.each_with_index { |row, y| row.each_with_index { |_, x| set << [x,y] } }
distances = set.map { |coord| [coord, Float::INFINITY] }.to_h
distances[start] = 0

until set.empty?
  loc = set.sort_by! { |coord| distances[coord] }.shift
  break if loc == goal
  surrounding = [
    [loc[0] + 1, loc[1]],
    [loc[0] - 1, loc[1]],
    [loc[0], loc[1] + 1],
    [loc[0], loc[1] - 1]
  ].filter do |coord|
    coord[0] >= 0 && coord[1] >= 0 &&
    set.include?(coord) &&
    grid.dig(coord[1], coord[0]) &&
    grid.dig(coord[1], coord[0]) <= grid.dig(loc[1], loc[0]) + 1
  end
  surrounding.each do |coord|
    dist_from_here = distances[loc] + 1
    distances[coord] = dist_from_here if dist_from_here < distances[coord]
  end
end

p distances[goal]

# part 2

grid = File.readlines('12.txt', chomp: true).map { |row| row.chars.map(&:codepoints).map(&:first) }

start, goal = nil
grid.each_with_index do |row, y|
  row.each_with_index do |square, x|
    start = [x,y] if square == 'S'.codepoints.first
    goal = [x,y] if square == 'E'.codepoints.first
  end
end

grid[start[1]][start[0]] = 'a'.codepoints.first
grid[goal[1]][goal[0]] = 'z'.codepoints.first

set = []
grid.each_with_index { |row, y| row.each_with_index { |_, x| set << [x,y] } }
distances = set.map { |coord| [coord, Float::INFINITY] }.to_h
distances[goal] = 0
a_squares = set.filter { |coord| grid[coord[1]][coord[0]] == 'a'.codepoints.first }

until set.empty?
  loc = set.sort_by! { |coord| distances[coord] }.shift
  surrounding = [
    [loc[0] + 1, loc[1]],
    [loc[0] - 1, loc[1]],
    [loc[0], loc[1] + 1],
    [loc[0], loc[1] - 1]
  ].filter do |coord|
    coord[0] >= 0 && coord[1] >= 0 &&
    set.include?(coord) &&
    grid.dig(coord[1], coord[0]) &&
    grid.dig(coord[1], coord[0]) >= grid.dig(loc[1], loc[0]) - 1
  end
  surrounding.each do |coord|
    dist_from_here = distances[loc] + 1
    distances[coord] = dist_from_here if dist_from_here < distances[coord]
  end
end

p a_squares.map { |coord| distances[coord] }.min
