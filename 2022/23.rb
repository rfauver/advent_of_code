data = File.readlines('23.txt', chomp: true)

elves = {}
data.each_with_index do |row, y|
  row.chars.each_with_index do |cell, x|
    elves[[x,y]] = true if cell == '#'
  end
end

dir_i = 0
dirs = [:n, :s, :w, :e]

10.times do
  proposals = {}

  elves.keys.each do |(x,y)|
    next unless elves[[x,y]]

    adjacent = false
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        next if dx == 0 && dy == 0
        adjacent = true if elves[[x+dx,y+dy]]
      end
      break if adjacent
    end
    next unless adjacent

    found = false
    0.upto(3) do |d_dir_i|
      case dirs[(dir_i+d_dir_i)%dirs.length]
      when :n
        if (-1..1).all? { |dx| !elves[[x+dx, y-1]] }
          proposals[[x,y-1]] ||= []
          proposals[[x,y-1]] << [x,y]
          found = true
        end
      when :s
        if (-1..1).all? { |dx| !elves[[x+dx, y+1]] }
          proposals[[x,y+1]] ||= []
          proposals[[x,y+1]] << [x,y]
          found = true
        end
      when :w
        if (-1..1).all? { |dy| !elves[[x-1, y+dy]] }
          proposals[[x-1,y]] ||= []
          proposals[[x-1,y]] << [x,y]
          found = true
        end
      when :e
        if (-1..1).all? { |dy| !elves[[x+1, y+dy]] }
          proposals[[x+1,y]] ||= []
          proposals[[x+1,y]] << [x,y]
          found = true
        end
      end
      break if found
    end
  end

  # p proposals

  proposals.each do |proposal, original_spots|
    if original_spots.length == 1

      elves[original_spots[0]] = nil
      elves[proposal] = true
    end
  end

  dir_i +=1


  # min_x, max_x = elves.keys.map(&:first).minmax
  # min_y, max_y = elves.keys.map(&:last).minmax

  # min_y.upto(max_y) do |y|
  #   min_x.upto(max_x) do |x|
  #     print elves[[x,y]] ? '#' : '.'
  #   end
  #   puts
  # end
  # puts
end

min_x, max_x = elves.keys.map(&:first).minmax
min_y, max_y = elves.keys.map(&:last).minmax

p ((max_x - min_x + 1) * (max_y - min_y + 1) - elves.values.filter(&:itself).count)

# part 2

elves = {}
data.each_with_index do |row, y|
  row.chars.each_with_index do |cell, x|
    elves[[x,y]] = true if cell == '#'
  end
end

dir_i = 0
last = nil

(0..).each do |i|
  proposals = {}

  elves.keys.each do |(x,y)|
    next unless elves[[x,y]]

    adjacent = false
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        next if dx == 0 && dy == 0
        adjacent = true if elves[[x+dx,y+dy]]
      end
      break if adjacent
    end
    next unless adjacent

    found = false
    0.upto(3) do |d_dir_i|
      case dirs[(dir_i+d_dir_i)%dirs.length]
      when :n
        if (-1..1).all? { |dx| !elves[[x+dx, y-1]] }
          proposals[[x,y-1]] ||= []
          proposals[[x,y-1]] << [x,y]
          found = true
        end
      when :s
        if (-1..1).all? { |dx| !elves[[x+dx, y+1]] }
          proposals[[x,y+1]] ||= []
          proposals[[x,y+1]] << [x,y]
          found = true
        end
      when :w
        if (-1..1).all? { |dy| !elves[[x-1, y+dy]] }
          proposals[[x-1,y]] ||= []
          proposals[[x-1,y]] << [x,y]
          found = true
        end
      when :e
        if (-1..1).all? { |dy| !elves[[x+1, y+dy]] }
          proposals[[x+1,y]] ||= []
          proposals[[x+1,y]] << [x,y]
          found = true
        end
      end
      break if found
    end
  end

  proposals.each do |proposal, original_spots|
    if original_spots.length == 1

      elves[original_spots[0]] = nil
      elves[proposal] = true
    end
  end

  dir_i +=1

  current = elves.filter { |k,v| v }.keys.to_s
  if current == last
    p i+1
    break
  end
  last = current
end

