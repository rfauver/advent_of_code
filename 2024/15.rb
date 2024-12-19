data = File.read("15.txt", chomp: true)

# part 1

@grid, directions = data.split("\n\n")
@grid = @grid.split("\n").map(&:chars)
directions = directions.chars

start = nil
@grid = @grid.each_with_index.map do |line, y|
  line.each_with_index.map do |char, x|
    if char == "@"
      start = [x, y]
      "."
    else
      char
    end
  end
end

def read_grid(coords)
  x, y = coords
  @grid.dig(y, x)
end

def write_grid(coords, char)
  x, y = coords
  @grid[y][x] = char
end

curr = start
directions.each do |dir|
  dx, dy = [0, 0]
  case dir
  when "^"
    dy = -1
  when ">"
    dx = 1
  when "v"
    dy = 1
  when "<"
    dx = -1
  end
  neighbor_coord = [curr[0] + dx, curr[1] + dy]
  neighbor = read_grid(neighbor_coord)
  if neighbor == "."
    curr = neighbor_coord
  elsif neighbor == "O"
    eol = neighbor_coord
    eol = [eol[0] + dx, eol[1] + dy] until ["#", "."].include?(read_grid(eol))
    if read_grid(eol) == "."
      curr = neighbor_coord
      write_grid(neighbor_coord, ".")
      write_grid(eol, "O")
    end
  end
end

total = 0

@grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next unless char == "O"
    total += y*100 + x
  end
end

p total

# part 2

@grid, directions = data.split("\n\n")
directions = directions.chars
@grid = @grid.split("\n").map(&:chars)
@grid = @grid.map do |line|
  line.flat_map do |char|
    case char
    when "#"
      ["#", "#"]
    when "."
      [".", "."]
    when "O"
      ["[", "]"]
    when "@"
      ["@", "."]
    end
  end
end

start = nil
@grid = @grid.each_with_index.map do |line, y|
  line.each_with_index.map do |char, x|
    if char == "@"
      start = [x, y]
      "."
    else
      char
    end
  end
end

def get_box_parts(coords, dy)
  parts = [coords]
  if read_grid(coords) == "["
    parts << [coords[0]+1, coords[1]]
  elsif read_grid(coords) == "]"
    parts << [coords[0]-1, coords[1]]
  end
  parts = parts.sort_by { |part| part[0] }
  above_first = read_grid([parts[0][0], parts[0][1] + dy])
  above_second = read_grid([parts[1][0], parts[1][1] + dy])
  if above_first == "["
    return parts + get_box_parts([parts[0][0], parts[0][1] + dy], dy)
  end
  if above_first == "]"
    parts += get_box_parts([parts[0][0], parts[0][1] + dy], dy)
  end
  if ["[", "]"].include?(above_second)
    parts += get_box_parts([parts[1][0], parts[1][1] + dy], dy)
  end
  parts
end

curr = start
directions.each do |dir|
  dx, dy = [0, 0]
  case dir
  when "^"
    dy = -1
  when ">"
    dx = 1
  when "v"
    dy = 1
  when "<"
    dx = -1
  end
  neighbor_coord = [curr[0] + dx, curr[1] + dy]
  neighbor = read_grid(neighbor_coord)
  if neighbor == "."
    curr = neighbor_coord
  elsif neighbor == "[" || neighbor == "]"
    if dir == "^" || dir == "v"
      parts = get_box_parts(neighbor_coord, dy)
      if (parts.all? { |part| read_grid([part[0], part[1] + dy]) != "#" })
        curr = neighbor_coord
        part_coords_to_chars = parts.map { |part| [part, read_grid(part)] }.to_h
        parts.each { |part| write_grid(part, ".") }
        parts.each { |part| write_grid([part[0], part[1] + dy], part_coords_to_chars[part]) }
      end
    else
      eol = neighbor_coord
      parts = []
      until ["#", "."].include?(read_grid(eol))
        parts << eol
        eol = [eol[0] + dx, eol[1]]
      end
      if read_grid(eol) == "."
        curr = neighbor_coord
        part_coords_to_chars = parts.map { |part| [part, read_grid(part)] }.to_h
        parts.each { |part| write_grid(part, ".") }
        parts.each { |part| write_grid([part[0] + dx, part[1]], part_coords_to_chars[part]) }

        write_grid(neighbor_coord, ".")
      end
    end
  end
end

total = 0

@grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next unless char == "["
    total += y*100 + x
  end
end

p total
