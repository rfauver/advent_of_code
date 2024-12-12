@grid = File.readlines("10.txt", chomp: true).map { |line| line.chars.map(&:to_i) }

starts = []

@grid.each_with_index do |line, y|
  line.each_with_index do |num, x|
    starts << [x, y] if num == 0
  end
end

# part 1

def search(x, y, seen)
  val = @grid.dig(y, x)
  return 0 if seen[[x,y]]
  seen[[x,y]] = true
  return 1 if val == 9

  neighbors = [[x-1,y], [x+1, y], [x, y-1], [x, y+1]]
  valid_neighbors = neighbors.select do |coords|
    coords.all? { |coord| coord >= 0 } && @grid.dig(coords.last, coords.first) == val + 1
  end
  valid_neighbors.sum { |(nx, ny)| search(nx, ny, seen) }
end

p starts.sum { |(x, y)| search(x, y, {}) }

# part 2

def search2(x, y)
  val = @grid.dig(y, x)
  return 1 if val == 9

  neighbors = [[x-1,y], [x+1, y], [x, y-1], [x, y+1]]
  valid_neighbors = neighbors.select do |coords|
    coords.all? { |coord| coord >= 0 } && @grid.dig(coords.last, coords.first) == val + 1
  end
  valid_neighbors.sum { |(nx, ny)| search2(nx, ny) }
end

p starts.sum { |(x, y)| search2(x, y) }
