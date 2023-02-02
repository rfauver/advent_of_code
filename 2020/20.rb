# part 1

tiles = File.read('/Users/rfauver/Desktop/data20.txt').split("\n\n");


tile_data = tiles.map do |tile|
  grid = tile.split("\n")
  id = grid.shift.match(/(\d+)/).captures.first.to_i
  top = grid.first
  bottom = grid.last
  left = grid.map { |row| row[0] }.join
  right = grid.map { |row| row[-1] }.join
  { id: id, grid: grid, edges: [top, bottom, left, right] }
end;


tile_data.each_with_index do |tile_a, i|
  tile_data.each_with_index do |tile_b, j|
    next if j <= i
    tile_a[:edges].each do |edge|
      match_index = tile_b[:edges].find_index(edge) || tile_b[:edges].find_index(edge.reverse)
      next unless match_index
      tile_b[:edges].delete_at(match_index)
      tile_a[:edges].delete(edge)
    end
  end
end;

tile_data.select { |tile| tile[:edges].length == 2 }.map { |tile| tile[:id] }.inject(&:*)


# part 2

def print_tile(tile)
  tile[:grid].each { |row| puts row }
end

def rotate_tile(tile, steps)
  return tile if [0,4].include?(steps)
  new_tile = { matches: tile[:matches].rotate(steps) }
  case steps
  when 1
    new_tile[:grid] = (0..(10-1)).map { |i| tile[:grid].map { |row| row[-(i+1)] }.join }
  when 2
    new_tile[:grid] = tile[:grid].map(&:reverse).reverse
  when 3
    new_tile[:grid] = (0..(10-1)).map { |i| tile[:grid].map { |row| row[-(i+1)] }.join }.map(&:reverse).reverse
  end
  new_tile[:edges] = build_edges(new_tile[:grid])
  new_tile
end

def reverse_tile(tile, axis)
  new_tile = { matches: tile[:matches]}
  case axis
  when :x
    new_tile[:grid] = tile[:grid].reverse
    hold = tile[:matches][0]
    new_tile[:matches][0] = tile[:matches][2]
    new_tile[:matches][2] = hold
  when :y
    new_tile[:grid] = tile[:grid].map(&:reverse)
    hold = tile[:matches][1]
    new_tile[:matches][1] = tile[:matches][3]
    new_tile[:matches][3] = hold
  end
  new_tile[:edges] = build_edges(new_tile[:grid])
  new_tile
end

def build_edges(grid)
  top = grid.first
  bottom = grid.last
  left = grid.map { |row| row[0] }.join
  right = grid.map { |row| row[-1] }.join
  [top, right, bottom, left]
end

def remove_edges(grid)
  grid.slice!(0)
  grid.slice!(-1)
  grid.each { |row| row.slice!(0); row.slice!(-1) }
end

def print_image(image)
  12.times do |y|
    tile_row = image.select { |k, v| k.end_with?(":#{y}") }
    10.times do |row_i|
      puts tile_row.map { |id, tile| tile[:grid][row_i] }.join('|')
    end
    puts ''
  end
end

# corners = [1621,3547,3389,1657]

tile_data = tiles.map do |tile|
  grid = tile.split("\n")
  id = grid.shift.match(/(\d+)/).captures.first.to_i
  [id, { grid: grid, edges: build_edges(grid), matches: Array.new(4) }]
end.to_h;

tile_data.each_with_index do |(id_a, tile_a), i|
  tile_data.each_with_index do |(id_b, tile_b), j|
    next if j <= i
    tile_a[:edges].each_with_index do |edge, edge_i|
      match_index = tile_b[:edges].find_index(edge) || tile_b[:edges].find_index(edge.reverse)
      next unless match_index
      tile_b[:matches][match_index] = id_a
      tile_a[:matches][edge_i] = id_b
      # break
    end
  end
end;

image = {}
cur_id = 1657

12.times do |y|
  temp_id = cur_id
  12.times do |x|
    cur_tile = tile_data[cur_id]
    image["#{x}:#{y}"] = cur_tile
    next if x == 11

    next_id = cur_tile[:matches][1]
    next unless next_id
    next_tile = tile_data[next_id]
    dir = next_tile[:matches].find_index { |match| match == cur_id }
    next_tile = rotate_tile(next_tile, dir+1)
    tile_data[next_id] = next_tile

    if cur_tile[:edges][1] == next_tile[:edges][3].reverse
      next_tile = reverse_tile(next_tile, :x)
      tile_data[next_id] = next_tile
    end

    if y != 0
      if next_tile[:edges][0] != image["#{x+1}:#{y-1}"][:edges][2]
        p [x, y, next_tile[:edges][0], image["#{x+1}:#{y-1}"][:edges][2]]
      end
    end
    cur_id = next_id
  end
  next if y == 11
  temp_tile = image["0:#{y}"]
  below_id = temp_tile[:matches][2]
  next unless below_id
  below_tile = tile_data[below_id]
  dir = below_tile[:matches].find_index { |match| match == temp_id }
  below_tile = rotate_tile(below_tile, dir)
  tile_data[below_id] = below_tile

  if temp_tile[:edges][2] == below_tile[:edges][0].reverse
    below_tile = reverse_tile(below_tile, :y)
    tile_data[below_id] = below_tile
  end
  cur_id = below_id
end

image_grid = []

12.times do |y|
  12.times do |x|
    remove_edges(image["#{x}:#{y}"][:grid])
  end
  tile_row = image.select { |k, v| k.end_with?(":#{y}") }
  8.times do |row_i|
    image_grid << tile_row.map { |id, tile| tile[:grid][row_i] }.join
  end
end

def mark_nessies(image_grid)
  found_any = false
  coords = [[0,0],[1,1],[4,1],[5,0],[6,0],[7,1],[10,1],[11,0],[12,0],[13,1],[16,1],[17,0],[18,0],[18,-1],[19,0]]
  image_grid.length.times do |y|
    next if y == 0
    next if y == image_grid.length - 1
    image_grid.first.length.times do |x|
      next if x > image_grid.first.length - 20
      if coords.all? { |(cx,cy)| image_grid[y+cy][x+cx] == '#' }
        found_any = true
        coords.each { |(cx,cy)| image_grid[y+cy][x+cx] = 'O' }
      end
    end
  end
  found_any
end

found = false
until found
  found = mark_nessies(image_grid)
  break if found
  image_grid = image_grid.reverse
  found = mark_nessies(image_grid)
  break if found
  image_grid = image_grid.reverse
  image_grid = image_grid.map(&:reverse)
  found = mark_nessies(image_grid)
  break if found
  image_grid = image_grid.map(&:reverse)

  image_grid = image_grid.length.times.map { |i| image_grid.map { |row| row[-(i+1)] }.join }
end

image_grid.join.count('#')
