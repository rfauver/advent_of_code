data = File.readlines('9.txt', chomp: true)

grid = data.map { |line| line.chars.map(&:to_i) }

# part 1

lows = []

grid.each_with_index do |row, y|
  row.each_with_index do |point, x|
    adjacents = []
    adjacents << grid.dig(y-1, x) if y > 0
    adjacents << grid.dig(y+1, x)
    adjacents << grid.dig(y, x-1) if x > 0
    adjacents << grid.dig(y, x+1)
    lows << point if adjacents.compact.all? { |adjacent| adjacent > point }
  end
end

p lows.map { |point| point + 1 }.sum

# part 2

lows = []

grid.each_with_index do |row, y|
  row.each_with_index do |point, x|
    adjacents = []
    adjacents << grid.dig(y-1, x) if y > 0
    adjacents << grid.dig(y+1, x)
    adjacents << grid.dig(y, x-1) if x > 0
    adjacents << grid.dig(y, x+1)
    lows << [x, y] if adjacents.compact.all? { |adjacent| adjacent > point }
  end
end

sizes = lows.map do |low|
  to_visit = [low]
  visited = {}
  until to_visit.empty?
    visiting = to_visit.dup
    to_visit = []
    visiting.each do |(x, y)|
      -1.upto(1) do |x_diff|
        -1.upto(1) do |y_diff|
          next if (x_diff + y_diff).abs != 1 || x + x_diff < 0 || y + y_diff < 0

          adjacent = grid.dig(y + y_diff, x + x_diff)
          if adjacent && adjacent != 9 && !visited[[x + x_diff, y + y_diff]]
            to_visit << [x + x_diff, y + y_diff]
          end
        end
      end
      visited[[x, y]] = true
    end
  end
  visited.length
end

p sizes.sort.reverse[0..2].inject(&:*)
