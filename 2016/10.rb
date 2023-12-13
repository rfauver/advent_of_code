data = File.readlines("10.txt", chomp: true)

# part 1 & 2

start_vals, rules_list = data.partition { |line| line.start_with?("value") }

vals = Hash.new { |h,k| h[k] = [] }

start_vals = start_vals.map do |line|
  val, bot = line.scan(/\d+/).map(&:to_i)
  vals[bot] << val
end

rules = {}

rules_list.each do |line|
  from, low, high = line.scan(/\d+/).map(&:to_i)
  low_output = line.match?(/low to output/)
  high_output = line.match?(/high to output/)

  rules[from] = {
    low: { output: low_output, dest: low },
    high: { output: high_output, dest: high },
  }
end

output = Hash.new { |h,k| h[k] = [] }

curr = vals.find { |bot, nums| nums.length == 2 }[0]

while curr
  low, high = vals[curr].minmax
  if low == 17 && high == 61
    p curr
  end

  low_rule = rules[curr][:low]
  high_rule = rules[curr][:high]

  vals[curr] = []
  if low_rule[:output]
    output[low_rule[:dest]] << low
  else
    vals[low_rule[:dest]] << low
  end
  if high_rule[:output]
    output[high_rule[:dest]] << high
  else
    vals[high_rule[:dest]] << high
  end

  curr = vals.find { |bot, nums| nums.length == 2 }&.first
end

p (output[0].first * output[1].first * output[2].first)
