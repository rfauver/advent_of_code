lines = File.readlines("04.txt", chomp: true)
grid = lines.map(&:chars)

# part 1

count = 0
search_string = "XMAS"
search_strings = [search_string, search_string.reverse]

grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    count += 1 if search_strings.include?(line[x...(x+4)].join)
    count += 1 if search_strings.include?(grid[y...(y+4)].map { |l| l[x]}.join )
    count += 1 if search_strings.include?(0.upto(3).map { |d| grid.dig(y + d, x + d)}.join)
    count += 1 if search_strings.include?(0.upto(3).map { |d| y - d < 0 ? "" : grid.dig(y - d, x + d)}.join)
  end
end

p count

# part 2

count = 0
search_string = "MAS"
search_strings = [search_string, search_string.reverse]
grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    count += 1 if search_strings.include?(0.upto(2).map { |d| grid.dig(y + d, x + d)}.join) &&
      search_strings.include?(0.upto(2).map { |d| grid.dig(y + 2 - d, x + d)}.join)
  end
end

p count
