data = File.readlines('11.txt', chomp: true)


# part 1

grid = data.map { |line| line.chars.map(&:to_i) }
total_flashes = 0

100.times do
  grid = grid.map { |line| line.map { |octo| octo + 1 } }

  current_flashes = Hash.new(nil)
  all_flashes = Hash.new(nil)
  loop do
    grid.each_with_index do |line, y|
      line.each_with_index do |octo, x|
        if grid[y][x] > 9
          current_flashes[[x, y]] = true
        end
      end
    end

    current_flashes.each do |(x, y), _|
      next if all_flashes[[x, y]]
      -1.upto(1) do |x_diff|
        -1.upto(1) do |y_diff|
          next if (x_diff == 0 && y_diff == 0) || x + x_diff < 0 || y + y_diff < 0

          if grid.dig(y + y_diff, x + x_diff)
            grid[y + y_diff][x + x_diff] += 1
          end
        end
      end
    end
    break if current_flashes == all_flashes

    all_flashes = all_flashes.merge(current_flashes)
  end

  grid.each_with_index do |line, y|
    line.each_with_index do |octo, x|
      if grid[y][x] > 9
        grid[y][x] = 0
      end
    end
  end

  total_flashes += all_flashes.size
end

p total_flashes

# part 2

grid = data.map { |line| line.chars.map(&:to_i) }

first = loop.with_index do |_, i|
  grid = grid.map { |line| line.map { |octo| octo + 1 } }

  current_flashes = Hash.new(nil)
  all_flashes = Hash.new(nil)
  loop do
    grid.each_with_index do |line, y|
      line.each_with_index do |octo, x|
        if grid[y][x] > 9
          current_flashes[[x, y]] = true
        end
      end
    end

    current_flashes.each do |(x, y), _|
      next if all_flashes[[x, y]]
      -1.upto(1) do |x_diff|
        -1.upto(1) do |y_diff|
          next if (x_diff == 0 && y_diff == 0) || x + x_diff < 0 || y + y_diff < 0

          if grid.dig(y + y_diff, x + x_diff)
            grid[y + y_diff][x + x_diff] += 1
          end
        end
      end
    end
    break if current_flashes == all_flashes

    all_flashes = all_flashes.merge(current_flashes)
  end

  grid.each_with_index do |line, y|
    line.each_with_index do |octo, x|
      if grid[y][x] > 9
        grid[y][x] = 0
      end
    end
  end

  break i if grid.all? { |line| line.all? { |octo| octo == 0 } }
end

p first + 1
