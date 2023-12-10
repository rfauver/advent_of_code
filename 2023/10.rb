data = File.readlines("10.txt", chomp: true)

# part 1

start = nil

data.each_with_index do |line, y|
  x = line.index("S")

  if x
    start = [x, y]
    break
  end
end

first_move = nil

if %w[7 | F].include?(data[start[1]-1][start[0]])
  first_move = { from_dir: :down, x: start[0], y: start[1]-1 }
elsif %w[L | J].include?(data[start[1]+1][start[0]])
  first_move = { from_dir: :up, x: start[0], y: start[1]+1 }
elsif %w[L - F].include?(data[start[1]][start[0]-1])
  first_move = { from_dir: :right, x: start[0]-1, y: start[1] }
elsif %w[J - 7].include?(data[start[1]][start[0]+1])
  first_move = { from_dir: :left, x: start[0]+1, y: start[1] }
end

loop_pieces = { start => "S" }
curr = first_move

until data[curr[:y]][curr[:x]] == "S"
  x = curr[:x]
  y = curr[:y]
  loop_pieces[[x,y]] = data[y][x]
  case curr[:from_dir]
  when :up
    case data[y][x]
    when "L"
      curr = { from_dir: :left, x: x + 1, y: y }
    when "|"
      curr = { from_dir: :up, x: x, y: y + 1 }
    when "J"
      curr = { from_dir: :right, x: x - 1, y: y }
    end
  when :down
    case data[y][x]
    when "F"
      curr = { from_dir: :left, x: x + 1, y: y }
    when "|"
      curr = { from_dir: :down, x: x, y: y - 1 }
    when "7"
      curr = { from_dir: :right, x: x - 1, y: y }
    end
  when :left
    case data[y][x]
    when "7"
      curr = { from_dir: :up, x: x, y: y + 1 }
    when "-"
      curr = { from_dir: :left, x: x + 1, y: y }
    when "J"
      curr = { from_dir: :down, x: x, y: y - 1 }
    end
  when :right
    case data[y][x]
    when "F"
      curr = { from_dir: :up, x: x, y: y + 1 }
    when "-"
      curr = { from_dir: :right, x: x - 1, y: y }
    when "L"
      curr = { from_dir: :down, x: x, y: y - 1 }
    end
  end
end

p loop_pieces.length / 2

# part 2

outside = {}
inside = {}

data.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    next if loop_pieces[[x,y]]

    seen_pieces = []
    x.downto(0) do |dx|
      if seen_pieces.length == 0 && outside[[dx,y]]
        outside[[x,y]] = true
        break
      elsif loop_pieces[[dx,y]]
        piece = loop_pieces[[dx,y]]
        seen_pieces << piece unless piece == "-"
      end
    end
    crossed = seen_pieces.join.reverse.scan(/(\||F7|FJ|LJ|L7)/).map(&:first).filter { |str| str != "F7" && str != "LJ" }

    if (crossed.count % 2) == 0
      outside[[x,y]] = true
    else
      inside[[x,y]] = true
    end
  end
end

p inside.length
