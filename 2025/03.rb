lines = File.readlines('03.txt', chomp: true)

# part 1
joltage = lines.map do |line|
  max1 = line[0...-1].chars.map(&:to_i).max.to_s
  index = line.chars.index(max1)
  max2 = line[index+1..].chars.map(&:to_i).max
  "#{max1}#{max2}".to_i
end

p joltage.sum

# part 2

def max_n(str, n)
  max = str[0..-n].chars.map(&:to_i).max.to_s
  index = str.chars.index(max)
  [max, index]
end

joltage = lines.map do |line|
  str = line
  nums = []
  12.downto(2) do |num|
    max, index = max_n(str, num)
    nums << max
    str = str[index+1..]
  end
  nums << str.chars.map(&:to_i).max
  nums.join.to_i
end

p joltage.sum
