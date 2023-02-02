data = File.readlines('14.txt', chomp: true)

chain = data.shift
data.shift
rules = data.to_h do |line|
  line.split(' -> ')
end

# part 1

10.times do
  new_chain = ''

  chain.chars.each_cons(2) do |(a, b)|
    middle = rules[[a,b].join]
    new_chain << [a, middle].join
  end
  new_chain << chain[-1]
  chain = new_chain
end

tally = chain.chars.tally

min, max = tally.values.minmax
p max - min

# part 2

data = File.readlines('14.txt', chomp: true)

chain = data.shift
chain_hash = Hash.new(0)
chain.chars.each_cons(2) do |(a, b)|
  chain_hash[[a,b].join] += 1
end

data.shift
rules = data.to_h do |line|
  line.split(' -> ')
end


40.times do |i|
  # puts i
  new_chain_hash = Hash.new(0)
  chain_hash.each do |pair, count|
    middle = rules[pair]
    # p middle + pair[1]
    new_chain_hash[pair[0] + middle] += count
    new_chain_hash[middle + pair[1]] += count
  end
  chain_hash = new_chain_hash
end

tally = chain_hash.reduce(Hash.new(0)) { |memo, (k, v)| memo[k[0]] += v; memo }
tally[chain[-1]] += 1

# chain = chain_hash.map { |k, v| k[0] * v }.sort.join + chain[-1]

# tally = chain.chars.tally

min, max = tally.values.minmax
p max - min
