moves = File.read("03.txt").chomp.chars

# part 1
curr = [0,0]
places = { curr => true }

moves.each do |move|
  x,y = curr
  case move
  when ">"
    curr = [x+1, y]
  when "v"
    curr = [x, y-1]
  when "<"
    curr = [x-1, y]
  when "^"
    curr = [x, y+1]
  end
  places[curr] = true
end

p places.length

# part 2
curr1 = [0,0]
curr2 = [0,0]

places = { curr1 => true }

def move(pos, move)
  x, y = pos
  case move
  when ">"
    [x+1, y]
  when "v"
    [x, y-1]
  when "<"
    [x-1, y]
  when "^"
    [x, y+1]
  end
end

moves.each_slice(2) do |mvs|
  curr1 = move(curr1, mvs.first)
  curr2 = move(curr2, mvs.last)

  places[curr1] = true
  places[curr2] = true
end

p places.length
