data = File.readlines('19.txt', chomp: true)

scanners = []
scanner_i = 0

data.each do |line|
  if line.include?('scanner')
    scanner_i = line.gsub('--- scanner ', '').gsub(' ---', '').to_i
  elsif line.include?(',')
    scanners[scanner_i] ||= []
    scanners[scanner_i] << line.split(',').map(&:to_i)
  end
end


# part 1

def rotate_around_z(x,y,z)
  [
    [x,y,z],
    [y,-x,z],
    [-x,-y,z],
    [-y,x,z]
  ]
end

def rotations(x,y,z)
  [
    *rotate_around_z(x,y,z),
    *rotate_around_z(-z,y,x),
    *rotate_around_z(-x,y,-z),
    *rotate_around_z(z,y,-x),
    *rotate_around_z(x,-z,y),
    *rotate_around_z(x,z,-y),
  ]
end

beacon_set = scanners[0].to_h { |beacon| [beacon, true] }
scanners_to_search = scanners[1..-1]
next_scanners_to_search = []
scanner_locations = [[0,0,0]]

until scanners_to_search.empty?
  scanners_to_search.each do |scanner_2|
    scanner_2_rotations = scanner_2.map { |beacon| rotations(*beacon) }.transpose

    found = nil

    0.upto(23) do |i|
      seen = {}
      beacon_set.keys.each_with_index do |beacon_1, j|
        scanner_2_rotations[i].each_with_index do |beacon_2, k|
          next if seen[[j,k]]

          seen[[j,k]] = true
          difference = beacon_2.zip(beacon_1).map{ |pair| pair.inject(&:-) }

          overlaps = scanner_2_rotations[i].count do |check_beacon|
            beacon_set[check_beacon.zip(difference).map{ |pair| pair.inject(&:-) }]
          end
          if overlaps >= 12
            found = difference
            scanner_locations << difference

            scanner_2_rotations[i].each do |move_beacon|
              beacon_set[move_beacon.zip(difference).map{ |pair| pair.inject(&:-) }] = true
            end
          end
          break if found
        end
        break if found
      end
      break if found
    end
    unless found
      next_scanners_to_search << scanner_2
    end
  end
  scanners_to_search = next_scanners_to_search.dup
  next_scanners_to_search = []
end
p beacon_set.count

# part 2

p scanner_locations.combination(2).map { |a, b| a.zip(b).sum { |v, w| (v - w).abs } }.max
