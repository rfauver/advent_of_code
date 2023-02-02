data = File.readlines('21.txt', chomp: true)

p1 = data.first[-1].to_i
p2 = data.last[-1].to_i

# part 1

p1_score = 0
p2_score = 0
goal = 1000


@curr_roll = 0
@roll_count = 0
def roll
  @roll_count += 1
  @curr_roll += 1
  @curr_roll = 1 if @curr_roll > 100
  @curr_roll
end

until p1_score >= goal || p2_score >= goal
  rolled = 3.times.map { roll }
  space = (p1 + rolled.sum - 1)%10 + 1
  p1_score += space
  p1 = space

  break if p1_score >= goal

  rolled = 3.times.map { roll }
  space = (p2 + rolled.sum - 1)%10 + 1
  p2_score += space
  p2 = space
end

puts [p1_score, p2_score].min * @roll_count

# part 2

data = File.readlines('21.txt', chomp: true)

p1 = data.first[-1].to_i
p2 = data.last[-1].to_i

@rolls = []
1.upto(3) do |x|
  1.upto(3) do |y|
    1.upto(3) do |z|
      @rolls << [x, y, z].sum
    end
  end
end
@roll_counts = @rolls.tally
@rolls = @roll_counts.keys

@wins = [0, 0]

def turn_for_player(player, roll, positions, scores, mult)
  space = (positions[player] + roll - 1)%10 + 1
  # puts "player: #{player}, roll: #{roll}, space: #{space}, step: #{step}, scores: [#{scores[0]}, #{scores[1]}]"
  new_scores = scores.dup
  new_scores[player] = scores[player] + space
  new_positions = positions.dup
  new_positions[player] = space

  if new_scores[player] >= 21
    @wins[player] += mult
    return
  end

  next_player = (player+1)%2

  p @wins[0] if @wins[0] % 100_000 == 0
  @rolls.each do |new_roll|
    turn_for_player(next_player, new_roll, new_positions, new_scores, mult * @roll_counts[new_roll])
  end
end

@rolls.each do |new_roll|
  turn_for_player(0, new_roll, [p1, p2], [0, 0], @roll_counts[new_roll])
end

p @wins.max
