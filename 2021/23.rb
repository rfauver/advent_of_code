data = File.readlines('23.txt', chomp: true)

grid = data.map(&:chars)
@energy_map = { 'A' => 1, 'B' => 10, 'C' => 100, 'D' => 1000 }

# part 1

map = {}
# pods = []

grid.each_with_index do |line, y|
  line.each_with_index do |char, x|
    next if ['#', ' '].include?(char)
    space = {}
    neighbors = [
      [x, y-1],
      [x, y+1],
      [x-1, y],
      [x+1, y]
    ].filter { |(nx, ny)| !['#', ' '].include?(grid.dig(ny, nx))  }
    space[:neighbors] = neighbors
    space[:window] = grid.dig(y-1, x) == '#' && grid.dig(y+1, x) != '#'
    if %w[A B C D].include?(char)
      space[:pod] = { loc: [x,y], let: char }
      space[:want] = %w[A B C D][(x-3)/2]
    end

    map[[x,y]] = space
  end
end

def possible_moves(move_from_loc, pod, map, visited, steps)
  possibilities = []
  map[move_from_loc][:neighbors].each do |neighbor|
    next if visited[neighbor]
    visited[neighbor] = true
    neighbor_space = map[neighbor]
    next if neighbor_space[:pod]
    next if neighbor_space[:want] && neighbor_space[:want] != pod[:let]
    unless neighbor_space[:window] || (neighbor_space[:want] && map[[neighbor[0], neighbor[1]+1]][:want])
      possibilities << [neighbor, steps+1]
    end
    possibilities += possible_moves(neighbor, pod, map, visited, steps+1)
  end
  possibilities
end

def energy_to_move_pod(pod_to_move, map)
  start_location = pod_to_move[:loc]

  possible_moves(start_location, pod_to_move, map, {}, 0).map do |(to_location, steps)|
    # p to_location
    energy = steps * @energy_map[pod_to_move[:let]]
    new_map = map.map.to_h do |location, attrs|
      if location == start_location
        [location, attrs.except(:pod)]
      elsif location == to_location
        [location, attrs.merge({ pod: pod_to_move.dup })]
      else
        [location, attrs]
      end
    end

    move_energy = new_map.filter do |_, attrs|
      attrs[:pod]
    end.map do |_, attrs|
      energy_to_move_pod(attrs[:pod], new_map)
    end.compact.min

    next nil if move_energy.nil?
    energy + move_energy
  end.compact.min
end

p (map.filter do |_, attrs|
  attrs[:pod]
end.map do |_, attrs|
  energy_to_move_pod(attrs[:pod], map)
end.compact.min)
