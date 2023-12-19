@grid = File.readlines("16.txt", chomp: true).map(&:chars)

# part 1

@visited = Hash.new { |h,v| h[v] = [] }

def laser(start, dir)
  return if @visited[start].include?(dir)
  x, y = start
  while x >= 0 && x < @grid.first.length && y >= 0 && y < @grid.length && @grid[y][x] == "."
    @visited[[x,y]] << dir
    case dir
    when :n
      y -= 1
    when :s
      y += 1
    when :e
      x += 1
    when :w
      x -= 1
    end
  end
  return if x < 0 || y < 0 || @grid.dig(y,x).nil?

  @visited[[x,y]] << dir
  case @grid.dig(y,x)
  when "|"
    if %i[n s].include?(dir)
      laser([x,dir == :n ? y-1 : y+1], dir)
    else
      laser([x,y-1], :n)
      laser([x,y+1], :s)
    end
  when "-"
    if %i[e w].include?(dir)
      laser([dir == :w ? x-1 : x+1,y], dir)
    else
      laser([x-1,y], :w)
      laser([x+1,y], :e)
    end
  when "/"
    case dir
    when :n
      laser([x+1,y], :e)
    when :s
      laser([x-1,y], :w)
    when :e
      laser([x,y-1], :n)
    when :w
      laser([x,y+1], :s)
    end
  when "\\"
    case dir
    when :n
      laser([x-1,y], :w)
    when :s
      laser([x+1,y], :e)
    when :e
      laser([x,y+1], :s)
    when :w
      laser([x,y-1], :n)
    end
  end
end

laser([0,0], :e)

# dir_to_char = { n: "^", s: "v", e: ">", w: "<" }

# @grid.each_with_index do |line, y|
#   line.each_with_index do |char, x|
#     if @visited[[x,y]].length > 1
#       print "x"
#     elsif @visited[[x,y]].length == 1
#       print dir_to_char[@visited[[x,y]].first]
#     else
#       print "."
#     end
#   end
#   puts
# end

p @visited.values.filter { |vals| vals.length > 0 }.length

# part 2

max = 0

@grid.first.each_with_index do |_, x|
  @visited = Hash.new { |h,v| h[v] = [] }
  laser([x,0], :s)
  count = @visited.values.filter { |vals| vals.length > 0 }.length
  max = count if count > max

  @visited = Hash.new { |h,v| h[v] = [] }
  laser([x,@grid.length - 1], :n)
  count = @visited.values.filter { |vals| vals.length > 0 }.length

  max = count if count > max
end

@grid.each_with_index do |_, y|
  @visited = Hash.new { |h,v| h[v] = [] }
  laser([0,y], :e)
  count = @visited.values.filter { |vals| vals.length > 0 }.length

  max = count if count > max

  @visited = Hash.new { |h,v| h[v] = [] }
  laser([@grid.first.length - 1,y], :n)
  count = @visited.values.filter { |vals| vals.length > 0 }.length

  max = count if count > max
end

p max
