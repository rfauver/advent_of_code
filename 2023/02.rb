data = File.readlines('02.txt', chomp: true)

# part 1

total = data.map do |line|
  max_red = line.scan(/(\d+) red/).map(&:first).map(&:to_i).max
  max_green = line.scan(/(\d+) green/).map(&:first).map(&:to_i).max
  max_blue = line.scan(/(\d+) blue/).map(&:first).map(&:to_i).max
  { possible: max_red <=12 && max_green <= 13 && max_blue <= 14, id: line.match(/Game (\d+)/)[1].to_i }
end.filter { |x| x[:possible] }.map { |x| x[:id] }.sum

p total

# part 2

total = data.map do |line|
  max_red = line.scan(/(\d+) red/).map(&:first).map(&:to_i).max
  max_green = line.scan(/(\d+) green/).map(&:first).map(&:to_i).max
  max_blue = line.scan(/(\d+) blue/).map(&:first).map(&:to_i).max
  max_red * max_green * max_blue
end.sum

p total
