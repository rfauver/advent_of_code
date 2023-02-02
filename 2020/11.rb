# part 1

data = File.read('/Users/rfauver/Desktop/data11.txt').split.map(&:chars);

def print_grid (grid)
  grid.each { |g| puts g.join }
end

grid = data.clone.map(&:clone);

(0..).each do |i|
  next_grid = grid.clone.map(&:clone)
  grid.each_with_index do |row, y|
    row.each_with_index do |seat, x|
      next if seat == '.'
      fulls = 0
      (-1..1).each do |offset_y|
        (-1..1).each do |offset_x|
          next if offset_x == 0 && offset_y == 0
          next if y+offset_y < 0 || y+offset_y >= grid.length
          next if x+offset_x < 0 || x+offset_x >= grid[y].length
          fulls += 1 if grid[y+offset_y][x+offset_x] == '#'
        end
      end
      next_grid[y][x] = '#' if fulls == 0 && seat == 'L'
      next_grid[y][x] = 'L' if fulls >= 4 && seat == '#'
    end
  end
  break if grid.map(&:join).join == next_grid.map(&:join).join
  grid = next_grid
end

grid.map(&:join).join.count('#')


# part 2
grid = data.clone.map(&:clone);

(0..).each do |i|
  next_grid = grid.clone.map(&:clone)
  grid.each_with_index do |row, y|
    row.each_with_index do |seat, x|
      next if seat == '.'
      fulls = 0
      (-1..1).each do |offset_y|
        (-1..1).each do |offset_x|
          next if offset_x == 0 && offset_y == 0
          cur_offset_x = offset_x
          cur_offset_y = offset_y
          loop do
            break if y+cur_offset_y < 0 || y+cur_offset_y >= grid.length
            break if x+cur_offset_x < 0 || x+cur_offset_x >= grid[y].length
            break if grid[y+cur_offset_y][x+cur_offset_x] != '.'
            cur_offset_x += offset_x
            cur_offset_y += offset_y
          end
          next if y+cur_offset_y < 0 || y+cur_offset_y >= grid.length
          next if x+cur_offset_x < 0 || x+cur_offset_x >= grid[y].length
          fulls += 1 if grid[y+cur_offset_y][x+cur_offset_x] == '#'
        end
      end
      next_grid[y][x] = '#' if fulls == 0 && seat == 'L'
      next_grid[y][x] = 'L' if fulls >= 5 && seat == '#'
    end
  end
  break if grid.map(&:join).join == next_grid.map(&:join).join
  grid = next_grid
end

grid.map(&:join).join.count('#')
