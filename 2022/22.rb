data = File.readlines('22.txt', chomp: true)

instructions = data.pop
instructions = instructions.split(/L|R/).map(&:to_i).zip(instructions.split(/\d+/)[1..]).flatten.filter(&:itself)
data.pop

grid = data.map(&:chars)

dir = :e
start_x = grid[0].find_index { |cell| ['.', '#'].include?(cell) }
curr = [start_x, 0]

turn_left = { n: :w, w: :s, s: :e, e: :n }
turn_right = { n: :e, e: :s, s: :w, w: :n }

def find_next(grid, curr, dir)
  x, y = curr
  new_x, new_y = [x, y]
  loop do
    # p [new_x, new_y]
    case dir
    when :n
      new_y -= 1
    when :s
      new_y += 1
    when :e
      new_x += 1
    when :w
      new_x -= 1
    end
    new_x %= grid[0].length
    new_y %= grid.length
    if grid.dig(new_y,new_x) == '.'
      return [new_x,new_y]
    elsif grid.dig(new_y,new_x) == '#'
      return [x,y]
    end
  end
end

instructions.each do |instruction|
  if instruction == 'L'
    dir = turn_left[dir]
    next
  elsif instruction == 'R'
    dir = turn_right[dir]
    next
  end

  instruction.times do
    prev = curr.clone
    curr = find_next(grid, curr, dir)
    break if prev == curr
  end
end

dir_value = { e: 0, s: 1, w: 2, n: 3 }

p (curr[1] + 1) * 1000 + (curr[0] + 1) * 4 + dir_value[dir]

# part 2

#              x
#                1 1
#            45 90 4
#          0 90 90 9
#              6  6
#              |  |
#    0        111222
#           4-111222-5
#    49       111222
#    50       333 |
# y          -333-
#    99     | 333
#    100   444555
#        1-444555-2
#    149   444555
#    150   666 |
#        1-666-
#    199   666
#           |
#           2

def find_next_around(grid, curr, dir)
  x, y = curr
  new_x, new_y = [x, y]
  new_dir = dir
  loop do
    # p [new_x, new_y]
    case dir
    when :n
      new_y -= 1
    when :s
      new_y += 1
    when :e
      new_x += 1
    when :w
      new_x -= 1
    end
    # 1 -> 4
    if x == 50 && (0..49).include?(y) && new_x == 49
      new_y = 149 - y
      new_x = 0
      new_dir = :e
    # 1 -> 6
    elsif y == 0 && (50..99).include?(x) && new_y == -1
      new_y = x + 100
      new_x = 0
      new_dir = :e
    # 2 -> 6
    elsif y == 0 && (100..149).include?(x) && new_y == -1
      new_y = 199
      new_x = x - 100
      new_dir = :n
    # 2 -> 5
    elsif x == 149 && (0..49).include?(y) && new_x == 150
      new_y = 149 - y
      new_x = 99
      new_dir = :w
    # 2 -> 3
    elsif y == 49 && (100..149).include?(x) && new_y == 50
      new_y = x - 50
      new_x = 99
      new_dir = :w
    # 3 -> 2
    elsif x == 99 && (50..99).include?(y) && new_x == 100
      new_y = 49
      new_x = y + 50
      new_dir = :n
    # 3 -> 4
    elsif x == 50 && (50..99).include?(y) && new_x == 49
      new_y = 100
      new_x = y - 50
      new_dir = :s
    # 4 -> 1
    elsif x == 0 && (100..149).include?(y) && new_x == -1
      new_y = 149 - y
      new_x = 50
      new_dir = :e
    # 4 -> 3
    elsif y == 100 && (0..49).include?(x) && new_y == 99
      new_y = x + 50
      new_x = 50
      new_dir = :e
    # 5 -> 2
    elsif x == 99 && (100..149).include?(y) && new_x == 100
      new_y = 149 - y
      new_x = 149
      new_dir = :w
    # 5 -> 6
    elsif y == 149 && (50..99).include?(x) && new_y == 150
      new_y = x + 100
      new_x = 49
      new_dir = :w
    # 6 -> 1
    elsif x == 0 && (150..199).include?(y) && new_x == -1
      new_y = 0
      new_x = y - 100
      new_dir = :s
    # 6 -> 2
    elsif y == 199 && (0..49).include?(x) && new_y == 200
      new_y = 0
      new_x = x + 100
      new_dir = :s
    # 6 -> 5
    elsif x == 49 && (150..199).include?(y) && new_x == 50
      new_y = 149
      new_x = y - 100
      new_dir = :n
    end

    if grid.dig(new_y,new_x) == '.'
      return { coord: [new_x,new_y], dir: new_dir }
    elsif grid.dig(new_y,new_x) == '#'
      return { coord: [x,y], dir: dir }
    end
  end
end

been_to = {}
dir_to_char = { n: '^', e: '>', s: 'v', w: '<' }

start_x = grid[0].find_index { |cell| ['.', '#'].include?(cell) }
curr = [start_x, 0]
dir = :e

instructions.each do |instruction|
  if instruction == 'L'
    dir = turn_left[dir]
    next
  elsif instruction == 'R'
    dir = turn_right[dir]
    next
  end

  instruction.times do
    prev = curr.clone
    result = find_next_around(grid, curr, dir)
    curr = result[:coord]
    dir = result[:dir]
    been_to[curr] = dir_to_char[dir]
    break if prev == curr
  end
end

# (0..199).each do |y|
#   (0..149).each do |x|
#     if been_to[[x,y]]
#       print been_to[[x,y]]
#     else
#       print grid[y][x]
#     end
#   end
#   puts
# end

p (curr[1] + 1) * 1000 + (curr[0] + 1) * 4 + dir_value[dir]
