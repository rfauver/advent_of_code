data = File.readlines("05.txt", chomp: true)

# part 1

seeds = data.shift.gsub("seeds: ", "").split(" ").map(&:to_i)

data.shift
data.shift

maps = []
curr_map_i = 0

data.select { |line| !line.empty? }.each do |line|
  maps[curr_map_i] = [] if maps[curr_map_i].nil?

  unless line.match(/\d/)
    curr_map_i += 1
    next
  end

  dest_start, source_start, range_length = line.split(" ").map(&:to_i)

  maps[curr_map_i] << { source_range: source_start..(source_start + range_length - 1), dest_range: dest_start..(dest_start + range_length - 1) }
end

min = Float::INFINITY

seeds.each do |seed|
  curr = seed
  maps.each do |ranges|
    found = ranges.find do |range|
      range[:source_range].include?(curr)
    end
    curr = found[:dest_range].begin + (curr - found[:source_range].begin) if found
  end
  min = curr if curr < min
end

p min

# part 2

min = Float::INFINITY

seeds.each_slice(2) do |pair|
  curr_ranges = [(pair[0]..(pair[0] + pair[1] - 1))]

  maps.each do |ranges|
    new_ranges = []
    until curr_ranges.empty?
      curr_range = curr_ranges.shift
      overlaps = false
      ranges.each do |range|
        source_range = range[:source_range]
        dest_range = range[:dest_range]

        next if overlaps
        if source_range.include?(curr_range.begin) && source_range.include?(curr_range.end)
          overlaps = true

          new_start = (dest_range.begin + (curr_range.begin - source_range.begin))
          new_end = (dest_range.end) - (source_range.end - curr_range.end)
          new_ranges << (new_start..new_end)
        elsif source_range.include?(curr_range.begin)
          overlaps = true

          curr_ranges << ((source_range.end+1)..curr_range.end)
          new_start = (dest_range.begin + (curr_range.begin - source_range.begin))
          new_ranges << (new_start..dest_range.end)
        elsif source_range.include?(curr_range.end)
          overlaps = true

          curr_ranges << (curr_range.begin..(source_range.begin-1))
          new_ranges << (dest_range.begin..(dest_range.begin + curr_range.end - source_range.begin))
        elsif curr_range.cover?(source_range)
          overlaps = true

          curr_ranges << (curr_range.begin..(source_range.begin-1))
          curr_ranges << ((source_range.end+1)..curr_range.end)
          new_ranges << dest_range
        end
      end
      new_ranges << curr_range unless overlaps
    end
    curr_ranges = new_ranges
  end
  lowest = curr_ranges.map(&:begin).min
  min = lowest if lowest < min
end

p min
