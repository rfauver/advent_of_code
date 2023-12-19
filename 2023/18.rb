steps = File.readlines("18.txt", chomp: true).map do |line|
  dir, count, color = line.split(" ")
  { dir: dir, count: count.to_i, color: color }
end

# part 1

curr = [0,0]

dug = { curr => true }

steps.each do |step|
  x, y = curr
  step[:count].times do
    case step[:dir]
    when "U"
      y -= 1
    when "D"
      y += 1
    when "L"
      x -= 1
    when "R"
      x += 1
    end
    dug[[x,y]] = true
  end
  curr = [x, y]
end

min_x, max_x = dug.keys.map { _1.first }.minmax
min_y, max_y = dug.keys.map { _1.last }.minmax

interior_point = nil
seen_edge = false
min_x.upto(max_x) do |x|
  if dug[[x,1]]
    if !seen_edge
      seen_edge = true
    end
  else
    if seen_edge
      interior_point = [x,1]
      break
    end
  end
end

to_search = [interior_point]

until to_search.length == 0
  curr = to_search.shift
  x, y = curr
  dug[curr] = true
  opts = [[x+1,y], [x-1,y], [x,y+1], [x,y-1]].filter do |coord|
    !dug[coord] && !to_search.include?(coord)
  end
  to_search += opts
end

# min_y.upto(max_y) do |y|
#   min_x.upto(max_x) do |x|
#     print dug[[x,y]] ? "#" : " "
#   end
#   puts
# end

p dug.keys.length

# part 2

steps = steps.map do |step|
  color = step[:color]
  count = color[2..6]
  dir = color[7].to_i
  dir = case dir
  when 0 then "R"
  when 1 then "D"
  when 2 then "L"
  when 3 then "U"
  end
  count = count.to_i(16)
  { dir: dir, count: count }
end

curr = [0,0]

points = [curr]

total = 0

steps.each do |step|
  x, y = curr
  case step[:dir]
  when "U"
    y -= step[:count]
  when "D"
    y += step[:count]
  when "L"
    x -= step[:count]
  when "R"
    x += step[:count]
  end
  total += (step[:count])
  points << [x,y]
  curr = [x, y]
end

# everything below: something something Shoelace something Pick's theorem

point_totals = points.each_cons(2).map do |(a, b)|
  ax, ay = a
  bx, by = b
  (ax * by) - (ay * bx)
end.sum

total = (point_totals/2).abs + total/2 + 1

p total
