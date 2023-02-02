data = File.readlines('13.txt', chomp: true)

grid = {}
folds = []
data.each do |line|
  if line.include?(',')
    grid[line.split(',').map(&:to_i)] = true
  elsif line.include?('fold')
    match_data = line.match(/fold along (.)=(\d+)/)
    folds << { dir: match_data[1], val: match_data[2].to_i }
  end
end

# part 1

folds.each_with_index do |fold, i|
  new_grid = grid.dup
  if fold[:dir] == 'x'
    grid.each do |(x, y), _|
      if x > fold[:val]
        new_grid.delete([x, y])
        new_grid[[2*fold[:val] - x, y]] = true
      end
    end
  else
    grid.each do |(x, y), _|
      if y > fold[:val]
        new_grid.delete([x, y])
        new_grid[[x, 2*fold[:val] - y]] = true
      end
    end
  end
  grid = new_grid
  p grid.length if i == 0
end

# part 2

min_x = Float::INFINITY
min_y = Float::INFINITY
max_x = 0
max_y = 0
grid.keys.each do |(x, y)|
  min_x = x if x < min_x
  min_y = y if y < min_y
  max_x = x if x > max_x
  max_y = y if y > max_y
end

min_y.upto(max_y) do |y|
  min_x.upto(max_x) do |x|
    print grid[[x, y]] ? '##' : '  '
  end
  puts
end
