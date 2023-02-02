# part 1

data = [13,16,0,12,15,1]

nums = data.dup
(nums.length..2020).each do |i|
  if !nums[0..-2].include?(nums.last)
    nums << 0
  else
    nums << (nums[0..-2].reverse.find_index(nums.last) + 1)
  end
end

nums[2019]



# part 2

nums = {13=>[0], 16=>[1], 0=>[2], 12=>[3], 15=>[4], 1=>[5]}
cur = 1

(nums.length..30000000).each do |i|
  puts i if i%100_000 == 0
  if nums[cur].length == 1
    nums[0] = [i, nums[0]&.first].compact
    cur = 0
  else
    distance = nums[cur].first - nums[cur].last
    nums[distance] = [i, nums[distance]&.first].compact
    cur = distance
  end
end

nums.find { |k, v| v.first === 29999999}
