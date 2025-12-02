data = File.read("01.txt", chomp: true)

# part 1
p data.count("(") - data.count(")")

# part 2
floor = 0
data.chars.each_with_index do |char, i|
  floor += char == "(" ? 1 : -1
  if floor == -1
    p i + 1
    break
  end
end
