class Cube
  attr_accessor :x1, :y1, :z1, :x2, :y2, :z2

  def initialize(coords)
    first, second = coords
    @x1, @y1, @z1 = first
    @x2, @y2, @z2 = second
  end

  def overlaps?(cube)
    cube.x1 <= @x2 && @x1 <= cube.x2 &&
    cube.y1 <= @y2 && @y1 <= cube.y2
  end

  def lower
    @z1 -= 1
    @z2 -= 1
  end

  def inspect
    "<Cube #{@x1}..#{@x2}, #{@y1}..#{@y2}, #{@z1}..#{@z2}>"
  end
end

# part 1

cubes = File.readlines("22.txt", chomp: true).map do |line|
  Cube.new(line.split("~").map { _1.split(",").map(&:to_i) })
end

cubes = cubes.sort_by { |cube| cube.z1 }

cubes.each_with_index do |cube, i|
  until cubes.any? { |lower_cube| lower_cube.z2 == cube.z1 - 1 && cube.overlaps?(lower_cube) }
    break if cube.z1 == 1
    cube.lower
  end
end

supporting_one = {}
supporting = Hash.new { |h,k| h[k] = [] }
on_top_of = Hash.new { |h,k| h[k] = [] }

cubes.each do |cube|
  lower = cubes.select { |lower_cube| lower_cube.z2 == cube.z1 - 1 && cube.overlaps?(lower_cube) }
  lower.each { |lower_cube| supporting[lower_cube] << cube }
  upper = cubes.select { |upper_cube| upper_cube.z1-1  == cube.z2 && cube.overlaps?(upper_cube) }
  upper.each { |upper_cube| on_top_of[upper_cube] << cube }
  if lower.length == 1
    supporting_one[lower.first] = true
  end
end

p cubes.length - supporting_one.length

# part 2

total = supporting_one.keys.map do |cube|
  above = []
  to_search = supporting[cube]
  until to_search.empty?
    curr = to_search.shift
    next if above.include?(curr)

    if on_top_of[curr].all? { |below| below == cube || above.include?(below) }
      above << curr

      to_search += supporting[curr]
    end
  end
  above.uniq.length
end.sum

p total
