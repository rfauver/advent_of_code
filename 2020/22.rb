# part 1

p1_start = %w[44 31 29 48 40 50 33 14 10 30 5 15 41 45 12 4 3 17 36 1 23 34 38 16 18].map(&:to_i)
p2_start = %w[24 20 11 32 43 9 6 27 35 2 46 21 7 49 26 39 8 19 42 22 47 28 25 13 37].map(&:to_i)

p1 = p1_start.dup
p2 = p2_start.dup

while p1.length > 0 && p2.length > 0
  card1 = p1.shift
  card2 = p2.shift
  if card1 > card2
    p1 << [card1, card2].max
    p1 << [card1, card2].min
  else
    p2 << [card1, card2].max
    p2 << [card1, card2].min
  end
end

winner = p1.length > 0 ? p1 : p2

winner.length.downto(1).sum do |i|
  winner[-i] * i
end



# part 2

def play_combat(p1_start, p2_start)
  p1 = p1_start.dup
  p2 = p2_start.dup
  rounds = {}

  while p1.length > 0 && p2.length > 0
    key = "#{p1.join(',')}:#{p2.join(',')}"
    return [:p1, p1] if rounds[key]
    rounds[key] = true

    card1 = p1.shift
    card2 = p2.shift

    if p1.length >= card1 && p2.length >= card2
      result = play_combat(p1.first(card1), p2.first(card2))
      if result.first == :p1
        winner = p1
        winning_card, losing_card = [card1, card2]
      else
        winner = p2
        winning_card, losing_card = [card2, card1]
      end
    elsif card1 > card2
      winner = p1
      winning_card, losing_card = [card1, card2]
    else
      winner = p2
      winning_card, losing_card = [card2, card1]
    end
    winner << winning_card
    winner << losing_card
  end

  p1.length > 0 ? [:p1, p1] : [:p2, p2]
end

winner = play_combat(p1_start, p2_start).last


winner.length.downto(1).sum do |i|
  winner[-i] * i
end
