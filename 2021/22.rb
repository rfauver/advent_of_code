data = File.readlines('22.txt', chomp: true)

instructions = data.map do |line|
  match_data = line.match(/(on|off) x=(.*)\.\.(.*),y=(.*)\.\.(.*),z=(.*)\.\.(.*)/)
  {
    state: match_data[1],
    ranges: match_data[2..7].map(&:to_i).each_slice(2).map { |(first, last)| first..last }
  }
end

# part 1

# grid = Hash.new(false)

# instructions.each do |instruction|
#   next unless instruction[:ranges].first.first.between?(-50, 50)

#   instruction[:ranges][0].each do |x|
#     instruction[:ranges][1].each do |y|
#       instruction[:ranges][2].each do |z|
#         if instruction[:state] == 'on'
#           grid[[x,y,z]] = true
#         else
#           grid.delete([x,y,z])
#         end
#       end
#     end
#   end
# end

# p grid.length

# part 2

total_volume = 0
cubes = {}

def overlaps?(range_a, range_b)
  range_b.begin <= range_a.end && range_a.begin <= range_b.end
end

def split_squares(square_a, square_b)
  sorted = [*square_a[1].minmax, *square_b[1].minmax].sort
  y_ranges = [
    sorted[0]..(sorted[1] - 1),
    sorted[1]..sorted[2],
    (sorted[2] + 1)..sorted[3],
  ]
  y_ranges.map do |range|
    x_ranges = [square_a, square_b].map do |square|
      if square[1].cover?(range)
        square[0]
      end
    end.compact
    [(x_ranges.map(&:min).min)..(x_ranges.map(&:max).max), range]
  end.filter { |ranges| ranges.all? { |range| range.begin } }
end

def split_cubes(cube_a, cube_b)
  return [cube_a] if cube_a.each_with_index.all? { |range, i| range.cover?(cube_b[i])}
  return [cube_b] if cube_b.each_with_index.all? { |range, i| range.cover?(cube_a[i])}

  sorted = [*cube_a[2].minmax, *cube_b[2].minmax].sort
  z_ranges = [
    sorted[0]..(sorted[1] - 1),
    sorted[1]..sorted[2],
    (sorted[2] + 1)..sorted[3],
  ]

  z_ranges.map do |range|
    xy_squares = [cube_a, cube_b].map do |cube|
      if cube[2].cover?(range)
        cube[0..1]
      end
    end.compact
    # p xy_squares
    if xy_squares.count == 1
      [[*xy_squares.first, range]]
    elsif xy_squares.count > 1
      split_squares(*xy_squares).map { |square| [*square, range] }
    end
  end.flatten(1).compact
end

def split_squares_off(on_square, off_square)
  return [on_square] unless on_square.each_with_index.all? { |range, i| overlaps?(range, off_square[i]) }

  sorted = [*on_square[1].minmax, *off_square[1].minmax].sort
  y_ranges = [
    sorted[0]..(sorted[1] - 1),
    sorted[1]..sorted[2],
    (sorted[2] + 1)..sorted[3],
  ]

  y_ranges.map do |range|
    if !on_square[1].cover?(range)
      next
    elsif off_square[1].cover?(range)
      [
        on_square[0].begin < off_square[0].begin ? [on_square[0].begin..(off_square[0].begin - 1), range] : nil,
        off_square[0].end < on_square[0].end ? [(off_square[0].end + 1)..on_square[0].end, range] : nil,
      ]
    else
      [[on_square[0], range]]
    end
  end.flatten(1).compact
end

def split_cubes_off(on_cube, off_cube)
  return [on_cube] unless on_cube.each_with_index.all? { |range, i| overlaps?(range, off_cube[i]) }

  sorted = [*on_cube[2].minmax, *off_cube[2].minmax].sort
  z_ranges = [
    sorted[0]..(sorted[1] - 1),
    sorted[1]..sorted[2],
    (sorted[2] + 1)..sorted[3],
  ]

  z_ranges.map do |range|
    if !on_cube[2].cover?(range)
      next
    elsif off_cube[2].cover?(range)
      split_squares_off(on_cube[0..1], off_cube[0..1]).map { |square| [*square, range] }
    else
      [[*on_cube[0..1], range]]
    end
  end.flatten(1).compact
end

instructions.each do |instruction|
  if instruction[:state] == 'off'
    collisions = cubes.keys.filter do |cube|
      cube.each_with_index.all? { |range, i| overlaps?(range, instruction[:ranges][i]) }
    end

    collisions.each do |collision|
      cubes.delete(collision)
      split_cubes_off(collision, instruction[:ranges]).each do |new_cube|
        cubes[new_cube] = true
      end
    end
    next
  end

  unchecked_cubes = [instruction[:ranges]]
  until unchecked_cubes.empty?
    collision = cubes.keys.find do |cube|
      cube.each_with_index.all? { |range, i| overlaps?(range, unchecked_cubes.first[i]) }
    end

    if collision
      subcubes = split_cubes(unchecked_cubes.shift, collision)
      cubes.delete(collision)
      unchecked_cubes += subcubes
    else
      cubes[unchecked_cubes.shift] = true
    end
  end
end

p cubes.keys.map { |cube| cube.map(&:size).inject(&:*) }.sum
