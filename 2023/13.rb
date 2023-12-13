data = File.readlines("13.txt", chomp: true).map(&:chars)

# part 1

grids = []
grid_i = 0

data.each do |line|
  if line.length == 0
    grid_i += 1
    next
  end
  grids[grid_i] = [] unless grids[grid_i]

  grids[grid_i] << line
end

scores = []

total = grids.map do |grid|
  max_x = grid.first.length

  score = nil
  (max_x + 1).times do |x|
    match = grid.all? do |line|
      first = line[0..x]
      second = line[x+1..-1] || ""
      length = [first.length, second.length].min
      length > 0 && first.reverse.first(length) == second.first(length)
    end
    if match
      score = x + 1
      break
    end
  end

  if score
    scores << { score: score, dir: :horizontal }
    next score
  end

  transposed = grid.transpose

  max_y = transposed.first.length

  (max_y + 1).times do |y|

    match = transposed.all? do |line|
      first = line[0..y]
      second = line[y+1..-1] || ""
      length = [first.length, second.length].min
      length > 0 && first.reverse.first(length) == second.first(length)
    end
    if match
      score = (y + 1) * 100
      break
    end
  end

  scores << { score: score, dir: :vertical }
  score
end.sum

p total

# part 2

total = grids.map.with_index do |grid, i|
  score = nil

  grid.each_with_index do |grid_line, dy|
    grid_line.each_with_index do |char, dx|

      new_grid = grid.map(&:clone )
      new_line = new_grid[dy].clone
      new_line[dx] = (new_grid[dy][dx] == "." ? "#" : ".")
      new_grid[dy] = new_line

      max_x = new_grid.first.length

      score = nil
      (max_x + 1).times do |x|
        next if scores[i][:dir] == :horizontal && (scores[i][:score] - 1) == x
        match = new_grid.all? do |line|
          first = line[0..x]
          second = line[x+1..-1] || ""
          length = [first.length, second.length].min
          length > 0 && first.reverse.first(length) == second.first(length)
        end
        if match
          score = x + 1
          break
        end
      end

      break if score

      transposed = new_grid.transpose

      max_y = transposed.first.length

      (max_y + 1).times do |y|
        next if scores[i][:dir] == :vertical && ((scores[i][:score]/100) - 1) == y
        match = transposed.all? do |line|
          first = line[0..y]
          second = line[y+1..-1] || ""
          length = [first.length, second.length].min
          length > 0 && first.reverse.first(length) == second.first(length)
        end
        if match
          score = (y + 1) * 100
          break
        end
      end
      break if score
    end
    break if score
  end

  score
end.sum

p total
