file = File.read("05.txt", chomp: true)

rules, updates = file.split("\n\n")
rules = rules.split("\n").map { |rule| rule.split("|") }
updates = updates.split("\n").map { |update| update.split(",") }

# part 1

valid_updates, invalid_updates = updates.partition do |update|
  update.each_with_index.all? do |page, i|
    invalid_prev_pages = rules.select { |rule| rule.first == page }.map(&:last)
    (update[0...i] & invalid_prev_pages) == []
  end
end

p valid_updates.map { |update| update[(update.length - 1) / 2].to_i }.sum

# part 2

fixed_updates = invalid_updates.map do |update|
  update.sort { |a, b| rules.select { |rule| rule.first == a }.map(&:last).include?(b) ? -1 : 1 }
end

p fixed_updates.map { |update| update[(update.length - 1) / 2].to_i }.sum
