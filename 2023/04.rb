data = File.readlines("04.txt", chomp: true).map { |line| line.gsub(/Card.*\d+: /, '').split(/ \|\s+/).map { |part| part.split(/\s+/).map(&:to_i) } }

# part 1

p data.map { |(winning, have)| (2 ** ((winning & have).length - 1)).truncate }.sum

# part 2

card_counts = Array.new(data.length) { 1 }
data.map.with_index { |(winning, have), i| (winning & have).length.times { |j| card_counts[i+j+1] += card_counts[i] } }

p card_counts.sum
