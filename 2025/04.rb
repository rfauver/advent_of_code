grid = File.readlines("04.txt", chomp: true).map(&:chars)

# part 1
count = 0

grid.each_with_index do |row, y|
  row.each_with_index do |char, x|
    next if char == "."
    rolls = 0
    -1.upto(1) do |dx|
      -1.upto(1) do |dy|
        next if dx.zero? && dy.zero?
        rolls += 1 if dx+x >= 0 && dy+y >= 0 && grid.dig(dy+y, dx+x) == "@"
      end
    end
    count += 1 if rolls < 4
  end
end

p count

# part 2
removed_count = 1
total = 0
while removed_count > 0
  to_remove = []
  grid.each_with_index do |row, y|
    row.each_with_index do |char, x|
      next if char == "."
      rolls = 0
      -1.upto(1) do |dx|
        -1.upto(1) do |dy|
          next if dx.zero? && dy.zero?
          rolls += 1 if dx+x >= 0 && dy+y >= 0 && grid.dig(dy+y, dx+x) == "@"
        end
      end
      to_remove << [x,y] if rolls < 4
    end
  end
  grid = grid.map.with_index do |row, y|
    row.map.with_index { |char, x| to_remove.include?([x,y]) ? "." : char }
  end
  removed_count = to_remove.length
  total += removed_count
end

p total
