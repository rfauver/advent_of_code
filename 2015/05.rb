lines = File.readlines("05.txt", chomp: true)

# part 1
vowels = /[aeiou]/
doubles = /(#{"abcdefghijklmnopqrstuvwxyz".chars.map { |char| char + char }.join("|")})/
bads = %w[ab cd pq xy]

p lines.count { |line| line.scan(vowels).length >= 3 && line.match?(doubles) && bads.none? { |bad| line.include?(bad)} }

# part 2
p lines.count { |line| 0.upto(line.length - 2).any? { |i| line[i+2..].include?(line[i..i+1]) } && 0.upto(line.length - 3).any? { |i| line[i] == line[i+2] } }
