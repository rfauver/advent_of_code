rounds = File.readlines('2.txt', chomp: true)

# part 1

score_for_move = {
  'X' => 1,
  'Y' => 2,
  'Z' => 3,
  'A' => 1,
  'B' => 2,
  'C' => 3,
}

score = 0
rounds.each do |round|
  opponent, mine = round.split(' ')
  score += score_for_move[mine]
  case opponent
  when 'A'
    case mine
    when 'X'
      score += 3
    when 'Y'
      score += 6
    when 'Z'
      score += 0
    end
  when 'B'
    case mine
    when 'X'
      score += 0
    when 'Y'
      score += 3
    when 'Z'
      score += 6
    end
  when 'C'
    case mine
    when 'X'
      score += 6
    when 'Y'
      score += 0
    when 'Z'
      score += 3
    end
  end
end

p score

# part 2


def move_for_result(opponent, desired_result)
  before = {
    'A' => 'C',
    'B' => 'A',
    'C' => 'B',
  }
  after = {
    'A' => 'B',
    'B' => 'C',
    'C' => 'A',
  }
  case desired_result
  when 'X'
    return before[opponent]
  when 'Y'
    return opponent
  when 'Z'
    return after[opponent]
  end
end

score = 0
rounds.each do |round|
  opponent, desired_result = round.split(' ')
  score += score_for_move[move_for_result(opponent, desired_result)]

  case desired_result
  when 'X'
    score += 0
  when 'Y'
    score += 3
  when 'Z'
    score += 6
  end
end

p score
