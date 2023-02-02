data = File.readlines('15.txt', chomp: true)

# part 1

sensors = data.map do |line|
  line.gsub('Sensor at x=', '').gsub(' y=', '').gsub(' closest beacon is at x=', '')
end.map do |line|
  line.split(':').map { |part| part.split(',').map(&:to_i) }
end

filled = {}

sensors.each do |(sensor, beacon)|
  distance = (sensor.first - beacon.first).abs + (sensor.last - beacon.last).abs
  (distance + 1).times do |i|
    x_range = (sensor.first - distance + i)..(sensor.first + distance - i)
    y1 = sensor.last - i
    y2 = sensor.last + i
    filled[y1] ||= []
    filled[y1] << x_range
    filled[y2] ||= []
    filled[y2] << x_range unless y2 == y1
  end
end

filled = filled.transform_values do |list|
  list.sort_by(&:begin).reduce([]) do |acc, range|
    next [range] if acc.empty?

    if acc.last.end >= range.begin - 1
      acc[0..-2] + [(acc.last.begin)..([range.end, acc.last.end].max)]
    else
      acc + [range]
    end
  end
end

# goal_row = 10
goal_row = 2000000

p (filled[goal_row].sum(&:size) - sensors.map(&:last).uniq.count { |beacon| beacon.last == goal_row })

# part 2

max_coord = 4000000

0.upto(max_coord) do |y|
  if filled[y].length > 1
    p ((filled[y].first.end + 1) * max_coord) + y
    break
  end
end

