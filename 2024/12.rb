@grid = File.readlines("12.txt", chomp: true).map(&:chars)

# part 1

@visited = {}
@regions = Hash.new { |h, k| h[k] = [] }
region_id = 0

def visit(x, y, char, region_id)
  return if @visited[[x,y]]
  @visited[[x,y]] = true

  neighbors = [[x-1, y, :l], [x+1, y, :r], [x, y-1, :u], [x, y+1, :d]]
  valid_neighbors, invalid_neighbors = neighbors.partition do |(dx, dy, _)|
    [dx, dy].all? { |coord| coord >= 0 } && @grid.dig(dy, dx) == char
  end
  @regions[region_id] << { x: x, y: y, fences: invalid_neighbors.map { |n| n[2] } }

  valid_neighbors.each do |neighbor|
    visit(neighbor[0], neighbor[1], char, region_id)
  end
end

@grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    unless @visited[[x,y]]
      visit(x, y, char, region_id)
      region_id += 1
    end
  end
end

p @regions.values.sum { |plots| plots.count * plots.sum { |plot| plot[:fences].length } }

# part 2

total = @regions.values.sum do |plots|
  sides = plots.sum do |plot|
    count = 0

    count += 1 if (plot[:fences] & [:l, :u]).length == 2
    count += 1 if (plot[:fences] & [:u, :r]).length == 2
    count += 1 if (plot[:fences] & [:r, :d]).length == 2
    count += 1 if (plot[:fences] & [:d, :l]).length == 2
    if (plot[:fences] & [:l, :u]).length == 0
      left = plots.find { |pl| pl[:x] == (plot[:x]-1) && pl[:y] == plot[:y] }
      top = plots.find { |pl| pl[:x] == (plot[:x]) && pl[:y] == (plot[:y]-1) }
      count += 1 if left && top && left[:fences].include?(:u) && top[:fences].include?(:l)
    end
    if (plot[:fences] & [:u, :r]).length == 0
      top = plots.find { |pl| pl[:x] == (plot[:x]) && pl[:y] == (plot[:y]-1) }
      right = plots.find { |pl| pl[:x] == (plot[:x]+1) && pl[:y] == plot[:y] }
      count += 1 if right && top && right[:fences].include?(:u) && top[:fences].include?(:r)
    end
    if (plot[:fences] & [:r, :d]).length == 0
      right = plots.find { |pl| pl[:x] == (plot[:x]+1) && pl[:y] == plot[:y] }
      bottom = plots.find { |pl| pl[:x] == (plot[:x]) && pl[:y] == (plot[:y]+1) }
      count += 1 if right && bottom && right[:fences].include?(:d) && bottom[:fences].include?(:r)
    end
    if (plot[:fences] & [:d, :l]).length == 0
      left = plots.find { |pl| pl[:x] == (plot[:x]-1) && pl[:y] == plot[:y] }
      bottom = plots.find { |pl| pl[:x] == (plot[:x]) && pl[:y] == (plot[:y]+1) }
      count += 1 if left && bottom && left[:fences].include?(:d) && bottom[:fences].include?(:l)
    end

    count
  end
  plots.count * sides
end

p total
