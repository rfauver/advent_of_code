sacks = File.readlines('3.txt', chomp: true)

# part 1

def priority(char)
  return char.codepoints.first - 96 if char.downcase == char
  char.codepoints.first - 38
end

p (sacks.map do |sack|
  compartments = sack.chars.partition.with_index { |_, i| i < sack.length/2 }
  common = (compartments[0] & compartments[1]).first
  priority(common)
end.sum)

# part 2

p (sacks.each_slice(3).map do |group|
  common = group.map(&:chars).reduce(&:&).first
  priority(common)
end.sum)

