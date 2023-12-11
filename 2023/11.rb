data = File.readlines("11.txt", chomp: true).map(&:chars)

# part 1

def print_image(img)
  img.each do |line|
    puts line.join
  end
end

expanded = data.reduce([]) do |arr, line|
  if line.uniq.length == 1
    arr << line
  end
  arr << line
  arr
end

expanded = expanded.transpose.reduce([]) do |arr, line|
  if line.uniq.length == 1
    arr << line
  end
  arr << line
  arr
end.transpose

points = []

expanded.each_with_index do |line, y|
  line.each_with_index do |char, x|
    points << [x,y] if char == "#"
  end
end

total = points.combination(2).map do |(a, b)|
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end.sum

p total

# part 2

points = []
blank_lines = []
blank_cols = []
expansion = 1_000_000

data.each_with_index do |line, y|
  blank_lines << y if line.uniq.length == 1
end

data.first.each_with_index do |char, x|
  blank_cols << x if data.map { |line| line[x] }.uniq.length == 1
end

data.each_with_index do |line, y|
  line.each_with_index do |char, x|
    points << [x,y] if char == "#"
  end
end

total = points.combination(2).map do |(a, b)|
  x_range = Range.new(*[a[0], b[0]].minmax)
  y_range = Range.new(*[a[1], b[1]].minmax)
  crossed_blank_cols = blank_cols.filter { |x| x_range.include?(x) }.length
  crossed_blank_lines = blank_lines.filter { |y| y_range.include?(y) }.length

  (a[0] - b[0]).abs + (a[1] - b[1]).abs + (crossed_blank_cols * (expansion - 1)) + (crossed_blank_lines * (expansion - 1))
end.sum

p total
