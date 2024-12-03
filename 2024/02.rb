lines = File.readlines("02.txt", chomp: true)

p (lines.count do |line|
  nums = line.split(" ").map(&:to_i)
  (nums == nums.sort || nums == nums.sort.reverse) && nums.sort.each_cons(2).all? { |(a, b)| a != b && b - a <= 3 }
end)


p (lines.count do |line|
  all_nums = line.split(" ").map(&:to_i)
  all_nums.combination(all_nums.length - 1).any? do |nums|
    (nums == nums.sort || nums == nums.sort.reverse) && nums.sort.each_cons(2).all? { |(a, b)| a != b && b - a <= 3 }
  end
end)
