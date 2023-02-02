elves = File.readlines('4.txt', chomp: true)

# part 1

p (elves.select do |elf_pair|
  ranges = elf_pair.gsub('-', '..').split(',').map { |str| eval(str) }
  ranges[0].cover?(ranges[1]) || ranges[1].cover?(ranges[0])
end.count)

# part 2

p (elves.select do |elf_pair|
  ranges = elf_pair.gsub('-', '..').split(',').map { |str| eval(str) }
  ranges[1].begin <= ranges[0].end && ranges[0].begin <= ranges[1].end
end.count)
