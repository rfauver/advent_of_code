grid = File.readlines('8.txt', chomp: true).map { |line| line.chars.map(&:to_i) }

# part 1

visible_count = 0
grid.each_with_index do |row, y|
  row.each_with_index do |tree, x|
    if x == 0 || y == 0 || x == grid[0].length - 1 || y == grid.length - 1
      visible_count += 1
      next
    end

    if 0.upto(x - 1).all? { |look_x| grid[y][look_x] < tree } ||
       (x + 1).upto(grid[0].length - 1).all? { |look_x| grid[y][look_x] < tree } ||
       0.upto(y - 1).all? { |look_y| grid[look_y][x] < tree } ||
       (y + 1).upto(grid.length - 1).all? { |look_y| grid[look_y][x] < tree }
      visible_count += 1
    end
  end
end

p visible_count

# part 2

max = 0
grid.each_with_index do |row, y|
  row.each_with_index do |tree, x|
    if x == 0 || y == 0 || x == grid[0].length - 1 || y == grid.length - 1
      next
    end

    if 0.upto(x - 1).all? { |look_x| grid[y][look_x] < tree } ||
       (x + 1).upto(grid[0].length - 1).all? { |look_x| grid[y][look_x] < tree } ||
       0.upto(y - 1).all? { |look_y| grid[look_y][x] < tree } ||
       (y + 1).upto(grid.length - 1).all? { |look_y| grid[look_y][x] < tree }
      visible_count += 1
    end

    can_see_1 = 0
    (x - 1).downto(0).each do |look_x|
      can_see_1 += 1
      break if grid[y][look_x] >= tree
    end

    can_see_2 = 0
    (x + 1).upto(grid[0].length - 1).each do |look_x|
      can_see_2 += 1
      break if grid[y][look_x] >= tree
    end

    can_see_3 = 0
    (y - 1).downto(0).each do |look_y|
      can_see_3 += 1
      break if grid[look_y][x] >= tree
    end

    can_see_4 = 0
    (y + 1).upto(grid.length - 1) do |look_y|
      can_see_4 += 1
      break if grid[look_y][x] >= tree
    end


    total = can_see_1 * can_see_2 * can_see_3 * can_see_4
    max = total if total > max
  end
end

p max
