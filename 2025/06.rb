lines = File.readlines("06.txt", chomp: true).map { |line| line.strip.split(/\s+/) }
# part 1
p (lines.transpose.sum do |line|
  op = line.pop
  line.map(&:to_i).reduce(&op.to_sym)
end)

# part 2
lines = File.readlines("06.txt", chomp: true).map(&:chars)

spaces = []
count = 0
lines.last.each do |char|
  if char != " "
    spaces << count if count > 0
    count = 0
  end
  count += 1
end
spaces << count

total = spaces.each_with_index.sum do |space, i|
  space += 1 if i == spaces.length - 1

  column = lines.map do |line|
    row = []
    (space-1).times { row << line.shift }
    line.shift
    row
  end
  operator = column.pop.join.strip
  column.map do |row|
    row.map { |item| (item&.match?(/\d+/) ? item : "") }
  end.transpose.map { |row| row.join.to_i }.reduce(&operator.to_sym)
end

p total
