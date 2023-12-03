data = File.readlines("24.txt", chomp: true)
@dirs = %w[< > ^ v]

# part 1

def print_table(x_size, y_size, table)
  y_size.times do |y|
    x_size.times do |x|
      if table[[x,y]]["#"]
        print "#"
      else
        blizzes = []
        @dirs.each do |char|
          blizzes << char if table[[x,y]][char]
        end
        print (blizzes.length == 0 ? "." : (blizzes.length == 1 ? blizzes.first : blizzes.length))
      end
    end
    puts
  end
end

maps = [{}]

start_map = data.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    maps[0][[x, y]] = {
      "#" => char == "#",
      ">" => char == ">",
      "<" => char == "<",
      "v" => char == "v",
      "^" => char == "^",
    }
  end
end

((data[0].length * data.length) - 1).times do |i|
  maps[i+1] = {}
  p i if i%10 == 0
  data.each_with_index do |line, y|
    line.chars.each_with_index do |_, x|
      maps[i+1][[x,y]] = {
        "#" => !!maps.dig(i, [x,y], "#"),
        ">" => x == 1 ? !!maps.dig(i, [line.length - 2, y],">") : !!maps.dig(i,[x-1, y],">"),
        "<" => x == line.length - 2 ? !!maps.dig(i,[1, y],"<") : !!maps.dig(i,[x+1, y],"<"),
        "v" => y == 1 ? !!maps.dig(i,[x, data.length - 2],"v") : !!maps.dig(i,[x, y-1],"v"),
        "^" => y == data.length - 2 ? !!maps.dig(i,[x, 1],"^") : !!maps.dig(i,[x, y+1],"^"),
      }
    end
  end
end


start = [1,0]
goal = [data.first.length - 2, data.length - 1]

# print_table(data.first.length, data.length, maps[0])
# # puts '----------'
# print_table(data.first.length, data.length, maps.last)

explored = {{coords: start, time: 0} => true}
queue = [{coords: start, time: 0}]

until queue.empty?
  curr = queue.shift
  if curr[:coords] == goal
    p curr[:time]
    break
  end
  next_time = curr[:time] + 1
  unless @dirs.any? { |dir| maps.dig(curr[:time] + 1, curr[:coords], dir) }
    queue << curr.merge({ time: next_time })
  end
  [
    [curr[:coords][0]-1, curr[:coords][1]],
    [curr[:coords][0]+1, curr[:coords][1]],
    [curr[:coords][0], curr[:coords][1]-1],
    [curr[:coords][0], curr[:coords][1]+1],
  ].select do |coords|
    coords.all? { |coord| coord >= 0 } && coords[0] < data.first.length && coords[1] < data.length
  end.each do |next_coords|
    next_spot = { coords: next_coords, time: next_time }
    unless explored[{ coords: next_coords, time: next_time%maps.length }] || (@dirs + ["#"]).any? { |dir| maps.dig(next_time%maps.length, next_coords, dir)}
      explored[{ coords: next_coords, time: next_time%maps.length }] = true
      queue << next_spot
    end
  end
end

# part 2

start = [1,0]
goal = [data.first.length - 2, data.length - 1]
explored = {{coords: start, time: 0} => true}
queue = [{coords: start, time: 0}]
end_spot = nil

until queue.empty?
  curr = queue.shift
  if curr[:coords] == goal
    end_spot = curr
    break
  end
  next_time = curr[:time] + 1
  unless @dirs.any? { |dir| maps.dig(curr[:time] + 1, curr[:coords], dir) }
    queue << curr.merge({ time: next_time })
  end
  [
    [curr[:coords][0]-1, curr[:coords][1]],
    [curr[:coords][0]+1, curr[:coords][1]],
    [curr[:coords][0], curr[:coords][1]-1],
    [curr[:coords][0], curr[:coords][1]+1],
  ].select do |coords|
    coords.all? { |coord| coord >= 0 } && coords[0] < data.first.length && coords[1] < data.length
  end.each do |next_coords|
    next_spot = { coords: next_coords, time: next_time }
    unless explored[{ coords: next_coords, time: next_time%maps.length }] || (@dirs + ["#"]).any? { |dir| maps.dig(next_time%maps.length, next_coords, dir)}
      explored[{ coords: next_coords, time: next_time%maps.length }] = true
      queue << next_spot
    end
  end
end

goal = [1, 0]
explored = {end_spot => true}
queue = [end_spot]
end_spot = nil

until queue.empty?
  curr = queue.shift
  if curr[:coords] == goal
    end_spot = curr
    break
  end
  next_time = curr[:time] + 1
  unless @dirs.any? { |dir| maps.dig(curr[:time] + 1, curr[:coords], dir) }
    queue << curr.merge({ time: next_time })
  end
  [
    [curr[:coords][0]-1, curr[:coords][1]],
    [curr[:coords][0]+1, curr[:coords][1]],
    [curr[:coords][0], curr[:coords][1]-1],
    [curr[:coords][0], curr[:coords][1]+1],
  ].select do |coords|
    coords.all? { |coord| coord >= 0 } && coords[0] < data.first.length && coords[1] < data.length
  end.each do |next_coords|
    next_spot = { coords: next_coords, time: next_time }
    unless explored[{ coords: next_coords, time: next_time%maps.length }] || (@dirs + ["#"]).any? { |dir| maps.dig(next_time%maps.length, next_coords, dir)}
      explored[{ coords: next_coords, time: next_time%maps.length }] = true
      queue << next_spot
    end
  end
end

goal = [data.first.length - 2, data.length - 1]
explored = {end_spot => true}
queue = [end_spot]
end_spot = nil

until queue.empty?
  curr = queue.shift
  if curr[:coords] == goal
    p curr[:time]
    break
  end
  next_time = curr[:time] + 1
  unless @dirs.any? { |dir| maps.dig(curr[:time] + 1, curr[:coords], dir) }
    queue << curr.merge({ time: next_time })
  end
  [
    [curr[:coords][0]-1, curr[:coords][1]],
    [curr[:coords][0]+1, curr[:coords][1]],
    [curr[:coords][0], curr[:coords][1]-1],
    [curr[:coords][0], curr[:coords][1]+1],
  ].select do |coords|
    coords.all? { |coord| coord >= 0 } && coords[0] < data.first.length && coords[1] < data.length
  end.each do |next_coords|
    next_spot = { coords: next_coords, time: next_time }
    unless explored[{ coords: next_coords, time: next_time%maps.length }] || (@dirs + ["#"]).any? { |dir| maps.dig(next_time%maps.length, next_coords, dir)}
      explored[{ coords: next_coords, time: next_time%maps.length }] = true
      queue << next_spot
    end
  end
end
