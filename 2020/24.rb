# part 1

data = File.read('/Users/rfauver/Desktop/data24.txt').split("\n");

list = data.map do |line|
  line.gsub('ne', '+').gsub('nw', '-').gsub('se', '#').gsub('sw', '$').chars.map do |char|
    case char
    when '+' then 'ne'
    when '-' then 'nw'
    when '#' then 'se'
    when '$' then 'sw'
    else char
    end
  end
end;

tiles = {}
list.each_with_index do |dirs, i|
  x = 0
  y = 0
  dirs.each do |dir|
    case dir
    when 'e'
      x += 1
    when 'w'
      x -= 1
    when 'ne'
      x += 1
      y += 1
    when 'nw'
      y += 1
    when 'se'
      y -= 1
    when 'sw'
      x -= 1
      y -= 1
    end
  end

  tiles[[x,y]] = !tiles[[x,y]]
end;

tiles.values.select(&:itself).count


# part 2

saved_tiles = tiles.dup;

tiles = saved_tiles.dup;
100.times do
  black_tiles = tiles.select { |coords, black| black }.map(&:first)
  min_x, max_x, min_y, max_y = black_tiles.transpose.map(&:minmax)

  new_tiles = tiles.dup
  ((min_x-1)..(max_x+1)).each do |x|
    ((min_y-1)..(max_y+1)).each do |y|
      adjacent_black_tiles = 0
      (-1..1).each do |cx|
        (-1..1).each do |cy|
          next if [[0,0], [1,-1], [-1, 1]].include?([cx, cy])
          adjacent_black_tiles += 1 if tiles[[x+cx,y+cy]]
        end
      end
      if tiles[[x,y]]
        new_tiles[[x,y]] = false if adjacent_black_tiles == 0
        new_tiles[[x,y]] = false if adjacent_black_tiles > 2
      else
        new_tiles[[x,y]] = true if adjacent_black_tiles == 2
      end
    end
  end
  tiles = new_tiles
end


tiles.values.select(&:itself).count
