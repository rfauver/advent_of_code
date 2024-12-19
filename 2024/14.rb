robots = File.readlines("14.txt", chomp: true).map do |line|
  left, right = line.split(" v=")
  { position: left[2..].split(",").map(&:to_i), velocity: right.split(",").map(&:to_i) }
end

# part 1

grid_width = 101
grid_height = 103

100.times do
  robots = robots.map do |robot|
    new_position = [
      (robot[:position][0] + robot[:velocity][0]) % grid_width,
      (robot[:position][1] + robot[:velocity][1]) % grid_height
    ]
    robot.merge({ position: new_position })
  end
end

q1 = [0...grid_width/2, 0...grid_height/2]
q2 = [(grid_width/2 + 1).., 0...grid_height/2]
q3 = [0...grid_width/2, (grid_height/2 + 1)..]
q4 = [(grid_width/2 + 1).., (grid_height/2 + 1)..]

count1 = 0
count2 = 0
count3 = 0
count4 = 0

robots.each do |robot|
  count1 += 1 if q1[0].include?(robot[:position][0]) && q1[1].include?(robot[:position][1])
  count2 += 1 if q2[0].include?(robot[:position][0]) && q2[1].include?(robot[:position][1])
  count3 += 1 if q3[0].include?(robot[:position][0]) && q3[1].include?(robot[:position][1])
  count4 += 1 if q4[0].include?(robot[:position][0]) && q4[1].include?(robot[:position][1])
end

p count1 * count2 * count3 * count4

# part 2

robots = File.readlines("14.txt", chomp: true).map do |line|
  left, right = line.split(" v=")
  { position: left[2..].split(",").map(&:to_i), velocity: right.split(",").map(&:to_i) }
end

min_distance_from_center = Float::INFINITY
center = [grid_width/2, grid_height/2]

1000000.times do |i|
  positions = Hash.new { |k, v| k[v] = 0 }
  robots = robots.map do |robot|
    new_position = [
      (robot[:position][0] + robot[:velocity][0]) % grid_width,
      (robot[:position][1] + robot[:velocity][1]) % grid_height
    ]
    positions[[robot[:position][0], robot[:position][1]]] += 1
    robot.merge({ position: new_position })
  end

  distance_from_center = positions.map { |k,v| ((k[0] - center[0]).abs + (k[1] - center[1]).abs) * v }.sum

  p i if i % 1000 == 0
  if distance_from_center < min_distance_from_center
    grid_height.times do |y|
      grid_width.times do |x|
        count = positions[[x,y]]
        print count > 0 ? count : "."
      end
      puts
    end
    puts i
    puts
  end
  min_distance_from_center = distance_from_center if distance_from_center < min_distance_from_center
end
