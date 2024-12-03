lines = File.readlines("01.txt", chomp: true)

# part 1

l1 = []
l2 = []

lines.each do |line|
  a, b = line.split('   ')
  l1 << a.to_i
  l2 << b.to_i
end

l1.sort!
l2.sort!

p l1.zip(l2).map { |(a, b)| (a - b).abs }.sum

# part 2

l2_count = l2.tally

p l1.map { |a| a * (l2_count[a] || 0) }.sum
