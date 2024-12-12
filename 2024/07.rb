lines = File.readlines("07.txt", chomp: true)

# part 1

tot = lines.filter_map do |line|
  total, nums = line.split(": ")
  total = total.to_i
  nums = nums.split(" ").map(&:to_i)
  operators = %i[* +].repeated_permutation(nums.length - 1)
  valid = operators.any? do |ops|
    i = 0
    nums.reduce do |memo, num|
      res = memo.send(ops[i], num)
      i += 1
      res
    end == total
  end
  total if valid
end.sum

p tot

# part 2

tot = lines.filter_map do |line|
  total, nums = line.split(": ")
  total = total.to_i
  nums = nums.split(" ").map(&:to_i)
  operators = %i[* + ||].repeated_permutation(nums.length - 1)
  valid = operators.any? do |ops|
    i = 0
    nums.reduce do |memo, num|
      res = if ops[i] == :"||"
        (memo.to_s + num.to_s).to_i
      else
        res = memo.send(ops[i], num)
      end
      i += 1
      res
    end == total
  end
  total if valid
end.sum

p tot
