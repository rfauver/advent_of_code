string = File.read("03.txt", chomp: true)

# part 1

p string.scan(/mul\(\d{1,3},\d{1,3}\)/).sum { |str| str.scan(/\d+/).map(&:to_i).reduce(&:*) }

# part 2

matches = string.scan(/(?:mul\(\d{1,3},\d{1,3}\))|(?:do\(\))|(?:don't\(\))/)
enabled = true
total = 0

matches.each do |str|
  if str.start_with?("don't")
    enabled = false
  elsif str.start_with?("do")
    enabled = true
  else
    total += str.scan(/\d+/).map(&:to_i).reduce(&:*) if enabled
  end
end

p total
