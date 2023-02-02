ef key(x, y, z)
  "#{x}:#{y}:#{z}"
end
def keys_to_ranges(keys)
  split = keys.map { |key| key.split(':').map(&:to_i) }
  mins = (0..2).map { |i| split.map { |k| k[i] }.min }
  maxs = (0..2).map { |i| split.map { |k| k[i] }.max }
  mins.zip(maxs).map { |(min, max)| (min-1)..(max+1) }
end

initial = %w[####...# ......#. #..#.##. .#...#.# ..###.#. ##.###.. .#...### .##....#]

# initial = %w[.#. ..# ###]
grid = Hash.new { '.' }
initial.each_with_index do |row, y|
  row.chars.each_with_index do |cube, x|
    grid[key(x,y,0)] = cube
  end
end

6.times do |step|
  ranges = keys_to_ranges(grid.keys)
  new_grid = grid.dup
  ranges[0].each do |x|
    ranges[1].each do |y|
      ranges[2].each do |z|
        actives = 0
        (-1..1).each do |i|
          (-1..1).each do |j|
            (-1..1).each do |k|
              next if [i, j, k].all?(0)
              actives += 1 if grid[key(x+i,y+j,z+k)] == '#'
            end
          end
        end
        new_grid[key(x,y,z)] = '.' if grid[key(x,y,z)] == '#' && ![2,3].include?(actives)
        new_grid[key(x,y,z)] = '#' if grid[key(x,y,z)] == '.' && actives == 3
      end
    end
  end
  grid = new_grid
end
grid.values.count { |v| v == '#' }



# part 2
def key(x, y, z, w)
  "#{x}:#{y}:#{z}:#{w}"
end
def keys_to_ranges(keys)
  split = keys.map { |key| key.split(':').map(&:to_i) }
  mins = (0..3).map { |i| split.map { |k| k[i] }.min }
  maxs = (0..3).map { |i| split.map { |k| k[i] }.max }
  mins.zip(maxs).map { |(min, max)| (min-1)..(max+1) }
end

initial = %w[####...# ......#. #..#.##. .#...#.# ..###.#. ##.###.. .#...### .##....#]
grid = Hash.new { '.' }
initial.each_with_index do |row, y|
  row.chars.each_with_index do |cube, x|
    grid[key(x,y,0,0)] = cube
  end
end

6.times do |step|
  ranges = keys_to_ranges(grid.keys)
  new_grid = grid.dup
  ranges[0].each do |x|
    ranges[1].each do |y|
      ranges[2].each do |z|
        ranges[2].each do |w|
          actives = 0
          (-1..1).each do |i|
            (-1..1).each do |j|
              (-1..1).each do |k|
                (-1..1).each do |l|
                  next if [i, j, k, l].all?(0)
                  actives += 1 if grid[key(x+i,y+j,z+k,w+l)] == '#'
                end
              end
            end
          end
          new_grid[key(x,y,z,w)] = '.' if grid[key(x,y,z,w)] == '#' && ![2,3].include?(actives)
          new_grid[key(x,y,z,w)] = '#' if grid[key(x,y,z,w)] == '.' && actives == 3
        end
      end
    end
  end
  grid = new_grid
end
grid.values.count { |v| v == '#' }
