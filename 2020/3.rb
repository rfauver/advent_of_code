@forest = File.read('/Users/rfauver/Desktop/data3.txt').split

# part 1

x = -3
@forest.count do |line|
  x += 3
  line[x % line.length] == '#'
end

# part 2

def get_hits(right, down)
  x = -right

  @forest.select.with_index do |line, i|
    next if i % down > 0
    x += right
    line[x % line.length] == '#'
  end.count
end

get_hits(1, 1) * get_hits(3, 1) * get_hits(5, 1) * get_hits(7, 1) * get_hits(1, 2)
