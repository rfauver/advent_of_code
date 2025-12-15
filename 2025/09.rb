tiles = File.readlines("09.txt", chomp: true).map { |line| line.split(",").map(&:to_i) }

# part 1
p (tiles.combination(2).map do |(tile1, tile2)|
  ((tile1[0] - tile2[0]).abs + 1) * ((tile1[1] - tile2[1]) + 1)
end.max)

# part 2
@edge_tiles = {}
@corners = {}
tiles.each_with_index do |tile, i|
  @corners[tile] = true
  next_tile = tiles[i+1] || tiles.first
  if tile[0] == next_tile[0]
    [tile[1], next_tile[1]].min.upto([tile[1], next_tile[1]].max) do |y|
      @edge_tiles[[tile[0], y]] = true
    end
  else
    [tile[0], next_tile[0]].min.upto([tile[0], next_tile[0]].max) do |x|
      @edge_tiles[[x, tile[1]]] = true
    end
  end
end

@max_x = @edge_tiles.keys.map(&:first).max + 1

@inside_cache = {}
def inside?(x, y)
  return @inside_cache[[x,y]] unless @inside_cache[[x,y]].nil?
  return true if @edge_tiles[[x,y]]

  corner_mode = nil

  seen_edges = 0
  (x+1).upto(@max_x) do |dx|
    if corner_mode
      if @corners[[dx,y]]
        if (corner_mode == :up && @edge_tiles[[dx,y+1]]) || (corner_mode == :down && @edge_tiles[[dx,y-1]])
          seen_edges += 1
        end
        corner_mode = nil
      end
    elsif @edge_tiles[[dx,y]]
      if @corners[[dx,y]]
        corner_mode = @edge_tiles[[dx,y-1]] ? :up : :down
      else
        seen_edges += 1
      end
    end
  end
  is_inside = seen_edges.odd?
  @inside_cache[[x,y]] = is_inside
  is_inside
end


outside_corners = tiles.map do |tile|
  around_corner_points = []
  -1.upto(1) do |x|
    -1.upto(1) do |y|
      next unless x.abs + y.abs == 2
      around_corner_points << [tile[0]+x, tile[1]+y]
    end
  end
  outside_points = around_corner_points.filter { |(x,y)| !inside?(x,y) }
  if outside_points.length > 1
    xs = outside_points.map(&:first)
    ys = outside_points.map(&:last)
    [xs.uniq.max_by { |x| xs.count(x) }, ys.uniq.max_by { |y| ys.count(y) }]
  else
    outside_points.first
  end
end

outside_edge = {}
outside_corners.each_with_index do |tile, i|
  next_tile = outside_corners[i+1] || outside_corners.first
  if tile[0] == next_tile[0]
    [tile[1], next_tile[1]].min.upto([tile[1], next_tile[1]].max) do |y|
      outside_edge[[tile[0], y]] = true
    end
  else
    [tile[0], next_tile[0]].min.upto([tile[0], next_tile[0]].max) do |x|
      outside_edge[[x, tile[1]]] = true
    end
  end
end

areas = tiles.combination(2).map.with_index do |(tile1, tile2)|
  horizontals = [tile1[0], tile2[0]].all? do |x|
    [tile1[1], tile2[1]].min.upto([tile1[1], tile2[1]].max).all? do |y|
      !outside_edge[[x,y]]
    end
  end
  verticals = [tile1[1], tile2[1]].all? do |y|
    [tile1[0], tile2[0]].min.upto([tile1[0], tile2[0]].max).all? do |x|
      !outside_edge[[x,y]]
    end
  end

  next 0 unless horizontals && verticals

  ((tile1[0] - tile2[0]).abs + 1) * ((tile1[1] - tile2[1]) + 1)
end

p areas.max
