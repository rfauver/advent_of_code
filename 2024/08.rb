grid = File.readlines("08.txt", chomp: true).map(&:chars)

antennas = Hash.new { |h, k| h[k] = [] }

grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next if char == "."
    antennas[char] << [x, y]
  end
end

# part 1

antinodes = {}

antennas.each do |char, nodes|
  nodes.combination(2) do |node_a, node_b|
    dx = node_a.first - node_b.first.abs
    dy = node_a.last - node_b.last.abs

    points = [[node_a.first + dx, node_a.last + dy], [node_b.first - dx, node_b.last - dy]]
    points.select do |point|
      point.first >= 0 && point.first < grid.first.length && point.last >= 0 && point.last < grid.length
    end.each do |point|
      antinodes[point] = true
    end
  end
end

p antinodes.count

# part 2

antinodes = {}

antennas.each do |char, nodes|
  nodes.combination(2) do |node_a, node_b|
    dx = node_a.first - node_b.first.abs
    dy = node_a.last - node_b.last.abs

    curr = node_a
    while curr.first >= 0 && curr.first < grid.first.length && curr.last >= 0 && curr.last < grid.length
      antinodes[curr] = true
      curr = [curr.first + dx, curr.last + dy]
    end
    curr = node_b
    while curr.first >= 0 && curr.first < grid.first.length && curr.last >= 0 && curr.last < grid.length
      antinodes[curr] = true
      curr = [curr.first - dx, curr.last - dy]
    end
  end
end

p antinodes.count
