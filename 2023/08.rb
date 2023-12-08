data = File.readlines("08.txt", chomp: true)

# part 1

instructions = data.shift
data.shift

nodes = data.map do |line|
  node, l_r = line.split(" = ")
  left, right = l_r.gsub("(", "").gsub(")", "").split(", ")
  [node, { left: left, right: right }]
end.to_h

step = 0
start = "AAA"
goal = "ZZZ"
curr = start

until curr == goal
  dir = instructions[step%instructions.length]
  if dir == "L"
    curr = nodes[curr][:left]
  else
    curr = nodes[curr][:right]
  end
  step += 1
end

p step

# part 2

start_nodes = nodes.keys.select { |n| n[2] == "A" }

steps = Hash.new { |h, k| h[k] = [] }
start_nodes.each do |node|
  step = 0
  curr = node

  until steps[node].length == 3
    dir = instructions[step%instructions.length]
    if dir == "L"
      curr = nodes[curr][:left]
    else
      curr = nodes[curr][:right]
    end
    step += 1
    steps[node] << step if curr[2] == "Z"
  end
end

p steps.values.map { |val| val.each_cons(2).map { |(a, b)| b - a } }.map(&:first).reduce(&:lcm)
