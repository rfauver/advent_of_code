data = File.readlines("25.txt", chomp: true)

def convert_place(char, i)
  int = { "2" => 2, "1" => 1, "0" => 0, "-" => -1, "=" => -2 }[char.to_s]
  (5 ** i) * int
end

def convert(line)
  line.reverse.chars.map.with_index do |char, i|
    convert_place(char, i)
  end.sum
end

total = data.map do |line|
  convert(line)
end.sum

i = 0
loop do
  if (5**i > total)
    break
  end
  i += 1
end

curr = i-2
num = Array.new(i) { 0 }
num[0] = 2

while curr >= 0
  next_char = %w[2 1 0 - =].map do |char|
    [char, (total - (convert(num.join) + convert_place(char, curr))).abs]
  end
  .min do |a, b|
    a[1] <=> b[1]
  end[0]
  num[num.length - curr - 1] = next_char
  curr -= 1
end

puts num.join

