moves = File.readlines("01.txt", chomp: true)

# part 1
place = 50
count = 0

moves.each do |move|
  place += (move[0] == "R" ? 1 : -1) * move[1..].to_i
  place %= 100
  count += 1 if place == 0
end

p count

# part 2
place = 50
count = 0

moves.each do |move|
  rotations = move[1..].to_i
  rotations.times do
    place += (move[0] == "R" ? 1 : -1)
    place %= 100
    count += 1 if place == 0
  end
end

p count
