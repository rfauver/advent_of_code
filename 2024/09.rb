data = File.read("09.txt", chomp: true).chars.map(&:to_i)

# part 1

disk = []
data.each_slice(2).with_index do |(file, free), i|
  disk += ([i] * file)
  disk += (["."] * free)
end

head = 0
tail = disk.length - 1

while head < tail
  head += 1 until disk[head] == "."
  tail -= 1 while disk[tail] == "."
  disk[head], disk[tail] = disk[tail], disk[head] unless head >= tail
end

p disk.map.with_index { |x, i| x == "." ? 0 : x * i }.sum

# part 2

disk = []
data.each_slice(2).with_index do |(file, free), i|
  disk += ([i] * file)
  disk += (["."] * free)
end

head = 0
tail = disk.length - 1

while head < tail
  head = 0
  tail -= 1 while disk[tail] == "."
  size = 1
  size += 1 until disk[(tail - size)..tail].uniq.length != 1

  if (!disk[head..tail].join.include?("." * size))
    tail -= size
    next
  end

  head += 1 until disk[head...(head + size)].uniq == ["."]

  disk[head...(head + size)], disk[(tail + 1 - size)..tail] = disk[(tail + 1 - size)..tail], disk[head...(head + size)] unless head >= tail
end

p disk.map.with_index { |x, i| x == "." ? 0 : x * i }.sum
