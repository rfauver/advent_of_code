cubes = File.readlines('18.txt', chomp: true).map { |n| n.split(',').map(&:to_i) }

sides = 0
cubes.each_with_index do |cube_1, i|
  # p i if i%100 == 0
  found = {}
  cubes.each do |cube_2|
    -1.upto(1) do |x|
      -1.upto(1) do |y|
        -1.upto(1) do |z|
          total = [x,y,z].map(&:abs).sum
          next unless total == 1
          found[[x,y,z]] = true if cube_1[0]+x == cube_2[0] && cube_1[1]+y == cube_2[1] && cube_1[2]+z == cube_2[2]
        end
      end
    end
    break if found.length == 6
  end
  sides += 6 - found.length
end

p sides

# part 2
cubes = File.readlines('18.txt', chomp: true).map { |n| [n.split(',').map(&:to_i), true] }.to_h

@max_x = cubes.keys.map(&:first).max
@max_y = cubes.keys.map { |n| n[1] }.max
@max_z = cubes.keys.map(&:last).max
@found = {}
@sides = 0

def search((x,y,z), cubes)
  @found[[x,y,z]] = true
  -1.upto(1) do |dx|
    next if dx == 0
    next @sides += 1 if cubes[[x+dx,y,z]]
    next if @found[[x+dx,y,z]]
    next if x+dx > @max_x+1 || x+dx < -1
    search([x+dx,y,z], cubes)
  end
  -1.upto(1) do |dy|
    next if dy == 0
    next @sides += 1 if cubes[[x,y+dy,z]]
    next if @found[[x,y+dy,z]]
    next if y+dy > @max_y+1 || y+dy < -1
    search([x,y+dy,z], cubes)
  end
  -1.upto(1) do |dz|
    next if dz == 0
    next @sides += 1 if cubes[[x,y,z+dz]]
    next if @found[[x,y,z+dz]]
    next if z+dz > @max_z+1 || z+dz < -1
    search([x,y,z+dz], cubes)
  end
end

search([0,0,0], cubes)

p @sides
