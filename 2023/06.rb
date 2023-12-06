data = File.readlines("06.txt", chomp: true)

# part 1

times = data.first.scan(/\d+/).map(&:to_i)
distances = data.last.scan(/\d+/).map(&:to_i)

winning_game_counts = times.map.with_index do |time, i|
  winning_game_count = 0
  1.upto(time) do |step|
    dist = (time - step) * step
    winning_game_count += 1 if dist > distances[i]
  end
  winning_game_count
end

p winning_game_counts.reduce(&:*)

# part 2

time = data.first.gsub(" ", "").match(/\d+/)[0].to_i
distance = data.last.gsub(" ", "").match(/\d+/)[0].to_i

winning_game_count = 0
found_win = false
1.upto(time) do |step|
  dist = (time - step) * step
  if dist > distance
    winning_game_count += 1
    found_win = true
  elsif found_win
    break
  end
end
p winning_game_count
