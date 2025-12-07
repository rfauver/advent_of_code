grid = File.readlines("07.txt", chomp: true).map(&:chars)

# part 2
visited = {}
grid.first.each_with_index { |char, x| visited[[x,0]] = true if char == "S" }

split_count = 0
grid.each_with_index do |row, y|
  row.each_with_index do |char, x|
    if visited[[x, y-1]]
      if char == "^"
        split_count += 1
        visited[[x-1,y]] = true
        visited[[x+1,y]] = true
      else
        visited[[x,y]] = true
      end
    end
  end
end

p split_count

# part 2
visited = Hash.new { 0 }
grid.first.each_with_index { |char, x| visited[[x,0]] = 1 if char == "S" }
grid.each_with_index do |row, y|
  row.each_with_index do |char, x|
    prev_count = visited[[x, y-1]]
    if prev_count > 0
      if char == "^"
        visited[[x-1,y]] += prev_count
        visited[[x+1,y]] += prev_count
      else
        visited[[x,y]] += prev_count
      end
    end
  end
end

p grid.last.each_with_index.sum { |_, x| visited[[x,grid.length - 1]] || 0 }
