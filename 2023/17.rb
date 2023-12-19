grid = File.readlines("17.txt", chomp: true).map { |line| line.chars.map(&:to_i) }

# part 1

visited = Hash.new { false }
to_visit = {}
distances = Hash.new { Float::INFINITY }

curr = [0,0, nil, 0]
goals = [1,2,3].map do |straight|
  [
    [grid.first.length - 1, grid.length - 1, :s, straight],
    [grid.first.length - 1, grid.length - 1, :e, straight],
  ]
end.flatten(1)

distances[curr] = 0

backwards = { n: :s, s: :n, e: :w, w: :e }

until goals.any? { |goal| visited[goal] }
  x, y, dir, straights = curr
  %i[n s e w].each do |new_dir|
    new_x, new_y = []
    case new_dir
    when :n
      new_x = x
      new_y = y-1
    when :s
      new_x = x
      new_y = y+1
    when :e
      new_x = x+1
      new_y = y
    when :w
      new_x = x-1
      new_y = y
    end
    new_straights = dir == new_dir ? straights + 1 : 1
    new_node = [new_x, new_y, new_dir, new_straights]
    next if new_y < 0 || new_y > grid.length - 1
    next if new_x < 0 || new_x > grid.first.length - 1
    next if backwards[new_dir] == dir
    next if visited[new_node]
    next if straights > 3
    cost = distances[curr] + grid[new_y][new_x]
    if cost < distances[new_node]
      distances[new_node] = cost
    end
    unless to_visit[new_node]
      to_visit[new_node] = true
    end
  end

  visited[curr] = true
  to_visit.delete(curr)

  curr = to_visit.keys.min { |a, b| distances[a] <=> distances[b] }
end

p goals.map { |goal| distances[goal] }.min

# part 2

def steps(y, new_y)
  min, max = [y, new_y].minmax
  (min..max).to_a.map do |dy|
    total = (min + (max - dy))
    next if total == y
    total
  end.compact
end

visited = Hash.new { false }
to_visit = {}
distances = Hash.new { Float::INFINITY }

curr = [0,0, nil, 0]
goals = [4,5,6,7,8,9,10].map do |straight|
  [
    [grid.first.length - 1, grid.length - 1, :s, straight],
    [grid.first.length - 1, grid.length - 1, :e, straight],
  ]
end.flatten(1)

distances[curr] = 0

backwards = { n: :s, s: :n, e: :w, w: :e }

until goals.any? { |goal| visited[goal] }
  x, y, dir, straights = curr
  %i[n s e w].each do |new_dir|
    next if backwards[new_dir] == dir
    new_x, new_y = []
    # cost_to_point = 0
    step_len = dir == new_dir ? 1 : 4
    case new_dir
    when :n
      new_x = x
      new_y = y-step_len
    when :s
      new_x = x
      new_y = y+step_len
    when :e
      new_x = x+step_len
      new_y = y
    when :w
      new_x = x-step_len
      new_y = y
    end
    new_straights = dir == new_dir ? straights + 1 : 4
    new_node = [new_x, new_y, new_dir, new_straights]
    next if new_y < 0 || new_y > grid.length - 1
    next if new_x < 0 || new_x > grid.first.length - 1
    next if visited[new_node]
    next if straights > 10
    cost_to_point = case new_dir
    when :n, :s
      steps(y, new_y).map { |step| grid[step][x] }.sum
    when :e, :w
      steps(x, new_x).map { |step| grid[y][step] }.sum
    end

    cost = distances[curr] + cost_to_point
    if cost < distances[new_node]
      distances[new_node] = cost
    end
    unless to_visit[new_node]
      to_visit[new_node] = true
    end
  end

  visited[curr] = true
  to_visit.delete(curr)

  curr = to_visit.keys.min { |a, b| distances[a] <=> distances[b] }
end

p goals.map { |goal| distances[goal] }.min
