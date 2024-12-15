original_stones = File.read("11.txt", chomp: true).split(" ").map(&:to_i)

# part 1

stones = original_stones
25.times do
  new_stones = []
  stones.each do |stone|
    string_stone = stone.to_s
    if stone == 0
      new_stones << 1
    elsif string_stone.length % 2 == 0
      new_stones << string_stone[0...(string_stone.length/2)].to_i
      new_stones << string_stone[(string_stone.length/2)..-1].to_i
    else
      new_stones << stone * 2024
    end
  end
  stones = new_stones
end

p stones.length

# part 2

stones = original_stones.tally

75.times do
  new_stones = Hash.new { |k, v| k[v] = 0 }
  stones.each do |stone, count|
    string_stone = stone.to_s
    if stone == 0
      new_stones[1] += count
    elsif string_stone.length % 2 == 0
      new_stones[string_stone[0...(string_stone.length/2)].to_i] += count
      new_stones[string_stone[(string_stone.length/2)..-1].to_i] += count
    else
      new_stones[stone * 2024] += count
    end
  end
  stones = new_stones
end

p stones.values.sum
