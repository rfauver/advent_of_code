lines = File.readlines("02.txt", chomp: true)

# part 1
totals = lines.map do |line|
  dimensions = line.split("x").map(&:to_i)
  areas = dimensions.combination(2).map { |(x, y)| x * y }
  paper = areas.map { |area| area * 2 }.sum
  paper + areas.min
end

p totals.sum

# part 2

totals = lines.map do |line|
  dimensions = line.split("x").map(&:to_i)
  sums = dimensions.combination(2).map(&:sum)
  sums.min * 2 + dimensions.reduce(&:*)
end

p totals.sum
