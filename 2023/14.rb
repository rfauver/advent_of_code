grid = File.readlines("14.txt", chomp: true).map(&:chars)

# part 1

total = 0

grid.transpose.each do |line|
  sections = line.join.split(/(?<=#)/)
  new_line = sections.map { |section| section.chars.sort_by { |char| char == "#" ? 3 : (char == "." ? 2 : 1) }}.join.chars
  new_line.each_with_index { |char, i| total += (new_line.length - i) if char == "O" }
end

p total

# part 2

dirs = %i[n w s e]
seen = Hash.new { 0 }
cycles = {}

def sort(str)
  str.chars.sort_by { |char| char == "#" ? 3 : (char == "." ? 2 : 1) }
end

(0..).each do |i|
  dir = dirs[i%dirs.length]
  cycle = i / dirs.length

  case dir
  when :n
    grid = grid.transpose.map do |line|
      sections = line.join.split(/(?<=#)/)
      sections.map { |section| sort(section) }.join.chars
    end.transpose
  when :w
    grid = grid.map do |line|
      sections = line.join.split(/(?<=#)/)
      sections.map { |section| sort(section) }.join.chars
    end
  when :s
    grid = grid.transpose.map do |line|
      sections = line.reverse.join.split(/(?<=#)/)
      sections.map { |section| sort(section) }.join.reverse.chars
    end.transpose
  when :e
    grid = grid.map do |line|
      sections = line.reverse.join.split(/(?<=#)/)
      sections.map { |section| sort(section) }.join.reverse.chars
    end
  end

  if (i % dirs.length) == 3
    hash_key = grid.map(&:join).join
    seen[hash_key] += 1
    cycles[cycle] = grid

    break if seen[hash_key] == 3
  end
end

start = seen.values.count(1)
cycle_length = seen.values.length - start

cycle = (1_000_000_000 - start) % cycle_length + start - 1

total = cycles[cycle].transpose.map do |line|
  line.map.with_index { |char, i| char == "O" ? (line.length - i) : 0 }.sum
end.sum

p total
