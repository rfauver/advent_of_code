data = File.readlines('01.txt', chomp: true)

total = data.map do |line|
  first = line.chars.find { |char| char.match(/\d/) }.to_i
  last = line.chars.reverse.find { |char| char.match(/\d/) }.to_i
  (first.to_s + last.to_s).to_i
end.sum
p total


total = data.map do |line|
  nums = { "one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9 }
  first_string = line.match(Regexp.new("(#{nums.keys.join("|")})"))
  first_num = line.match(/\d/)
  last_string = line.reverse.match(Regexp.new("(#{nums.keys.map(&:reverse).join("|")})"))
  last_num = line.reverse.match(/\d/)

  first = ((first_string&.begin(0) || 100) < (first_num&.begin(0) || 100)) ? nums[first_string[0]].to_s : first_num[0].to_s
  last = ((last_string&.begin(0) || 100) < (last_num&.begin(0) || 100)) ? nums[last_string[0].reverse].to_s : last_num[0].to_s
  (first + last).to_i
end.sum
p total
