jets = File.read('17.txt', chomp: true).chars.filter { |c| ['<', '>'].include?(c) }

# part 1
shapes = [
  [[0,0],[1,0],[2,0],[3,0]],
  [[1,0],[0,1],[1,1],[2,1],[1,2]],
  [[0,0],[1,0],[2,0],[2,1],[2,2]],
  [[0,0],[0,1],[0,2],[0,3]],
  [[0,0],[1,0],[0,1],[1,1]]
]

rocks = {
  [0,0] => true, [1,0] => true, [2,0] => true, [3,0] => true, [4,0] => true, [5,0] => true, [6,0] => true
}
jet_index = 0

def print_rocks(rocks)
  min_x, max_x = rocks.keys.map(&:first).minmax
  min_y, max_y = rocks.keys.map(&:last).minmax
  max_y.downto(min_y) do |y|
    min_x.upto(max_x) do |x|
      print rocks[[x,y]] ? '#' : '.'
    end
    puts
  end
end

heights = []

2022.times do |i|
  shape = shapes[i%shapes.length]

  stopped = false
  x = 2
  y = rocks.keys.map(&:last).max + 4

  until stopped
    jet = jets[jet_index%jets.length]

    if jet == '<'
      open_space = shape.all? do |(dx,dy)|
        new_x = x+dx-1
        new_x >= 0 && new_x <= 6 && !rocks[[new_x,y+dy]]
      end
      x -=1 if open_space
    else
      open_space = shape.all? do |(dx,dy)|
        new_x = x+dx+1
        new_x >= 0 && new_x <= 6 && !rocks[[new_x,y+dy]]
      end
      x +=1 if open_space
    end

    if shape.all? { |(dx,dy)| !rocks[[x+dx,y+dy-1]] }
      y -= 1
    else
      stopped = true
      shape.each { |(dx,dy)| rocks[[x+dx,y+dy]] = true }
    end

    jet_index += 1
  end
  heights[i] = rocks.keys.map(&:last).max

  # p i-1745 if (i - 1745 > 0 && heights[i] - heights[i-1745] == 2752)
  # print_rocks(rocks)
  # puts
  # p [i, jet_index%jets.length, heights[i]]
end
# print_rocks(rocks)

p rocks.keys.map(&:last).max


# part 2

# 337 +
# (1000000000000 - 215)/1745 * 2752 => 1577077362304
# (1000000000000 - 215)%1745 => 796

# heights[214+796] - heights[214] =>  1274
# 337 + 1577077362304 + 1274
