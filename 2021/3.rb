data = File.readlines('3.txt', chomp: true)

# part 1
gamma = []
epsilon = []

data.map(&:chars).transpose.each do |line|
  tally = line.tally
  gamma << (tally['0'] > tally['1'] ? '0' : '1')
  epsilon << (tally['0'] > tally['1'] ? '1' : '0')
end

puts gamma.join.to_i(2) * epsilon.join.to_i(2)


# part 2

oxy = nil
current = data
0.upto(current.first.length) do |i|
  tally = current.map { |line| line[i] }.tally
  max = (tally['1'] >= tally['0'] ? '1' : '0')
  current = current.select { |line| line[i] == max }
  break if current.length == 1
end
oxy = current.first

co2 = nil
current = data
0.upto(current.first.length) do |i|
  tally = current.map { |line| line[i] }.tally
  max = (tally['1'] >= tally['0'] ? '0' : '1')
  current = current.select { |line| line[i] == max }
  break if current.length == 1
end
co2 = current.first

puts oxy.to_i(2) * co2.to_i(2)
