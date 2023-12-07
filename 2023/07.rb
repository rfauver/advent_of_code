data = File.readlines("07.txt", chomp: true)

# part 1

@values = { "A"=>14, "K"=>13, "Q"=>12, "J"=>11, "T"=>10, "9"=>9, "8"=>8, "7"=>7, "6"=>6, "5"=>5, "4"=>4, "3"=>3, "2"=>2 }

values = data.map do |line|
  hand, bid = line.split(" ")
  grouped = hand.chars.group_by { |char| char }
  value = if hand.chars.uniq.length == 1
    7
  elsif grouped.values.any? { |group| group.length == 4 }
    6
  elsif grouped.values.any? { |group| group.length == 3 } && grouped.values.any? { |group| group.length == 2 }
    5
  elsif grouped.values.any? { |group| group.length == 3 }
    4
  elsif grouped.values.map(&:length).count(2) == 2
    3
  elsif grouped.values.any? { |group| group.length == 2 }
    2
  else
    1
  end
  { hand: hand, bid: bid.to_i, value: value }
end

total = values.sort_by do |val|
  [val[:value]] + val[:hand].chars.map { |char| @values[char] }
end.map.with_index do |value, i|
  value[:bid] * (i + 1)
end.sum

p total

# part 2

@values_2 = { "A"=>14, "K"=>13, "Q"=>12, "J"=>1, "T"=>10, "9"=>9, "8"=>8, "7"=>7, "6"=>6, "5"=>5, "4"=>4, "3"=>3, "2"=>2 }

values = data.map do |line|
  hand, bid = line.split(" ")
  grouped = hand.chars.group_by { |char| char }
  j_count = grouped["J"]&.length || 0
  value = if hand.chars.uniq.length == 1 || (hand.chars.uniq.length == 2 && j_count > 0)
    7
  elsif grouped.reject { |k,v| k == "J" }.values.any? { |group| (group.length + j_count) == 4 } || j_count == 4
    6
  elsif (grouped.values.any? { |group| group.length == 3 } && grouped.values.any? { |group| group.length == 2 }) ||
        (j_count == 1 && grouped.reject { |k,v| k == "J" }.values.map(&:length).count(2) == 2)
    5
  elsif grouped.values.any? { |group| (group.length + j_count) == 3 }
    4
  elsif grouped.values.map(&:length).count(2) == 2
    3
  elsif grouped.values.any? { |group| (group.length + j_count) == 2 }
    2
  else
    1
  end
  { hand: hand, bid: bid.to_i, value: value }
end

total = values.sort_by do |val|
  [val[:value]] + val[:hand].chars.map { |char| @values_2[char] }
end.map.with_index do |value, i|
  value[:bid] * (i + 1)
end.sum

p total
