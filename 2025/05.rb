data = File.readlines("05.txt", chomp: true);

# part 1
ranges = []
ingredients = []
data.each do |line|
  if line.include?("-")
    ranges << line.split("-").to_a.map(&:to_i)
  elsif line != ""
    ingredients << line.to_i
  end
end

ranges = ranges.map { |(a, b)| a..b }

p ingredients.count { |ingredient| ranges.any? { |range| range.include?(ingredient) } }

# part 2
prev_length = 0
while ranges.length != prev_length
  prev_length = ranges.length
  new_ranges = []
  until ranges.empty?
    range = ranges.shift
    i = ranges.find_index { |r2| range.overlap?(r2) }
    matched = i ? ranges.delete_at(i) : nil
    new_ranges << (matched ? ([range.min, matched.min].min..[range.max, matched.max].max) : range)
  end
  ranges = new_ranges.dup
end

p ranges.sum(&:size)
