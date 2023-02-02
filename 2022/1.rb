elves = File.readlines('1.txt', chomp: true).join(',').split(',,').map { |s| s.split(',').map(&:to_i) }

# part 1
p elves.map { |elf| elf.sum }.max

# part 2
p elves.map { |elf| elf.sum }.sort.last(3).sum
