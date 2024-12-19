data = File.read("13.txt", chomp: true)

# part 1

machines = data.split("\n\n").map do |m|
  lines = m.split("\n")
  a = lines[0].scan(/\d+/).map(&:to_i)
  b = lines[1].scan(/\d+/).map(&:to_i)
  prize = lines[2].scan(/\d+/).map(&:to_i)
  { a: a, b: b, prize: prize }
end

total = machines.filter_map do |machine|
  min = Float::INFINITY
  1.upto(100) do |a|
    1.upto(100) do |b|
      total_x = a * machine[:a][0] + b * machine[:b][0]
      total_y = a * machine[:a][1] + b * machine[:b][1]
      if total_x == machine[:prize][0] && total_y == machine[:prize][1]
        cost = (a * 3) + b
        min = cost if cost < min
      end
      break if total_x > machine[:prize][0] || total_y > machine[:prize][1]
    end
  end
  min if min != Float::INFINITY
end.sum

p total

# part 2

def solve_system(a, b, c, d, e, f)
  determinant = (a * d) - (b * c)
  return nil if determinant == 0
  x = ((d * e) - (b * f)) / determinant
  y = ((a * f) - (c * e)) / determinant
  return [x, y]
end

machines = machines.map do |machine|
  machine.merge({ prize: machine[:prize].map { |pr| pr + 10000000000000 } })
end

total = machines.filter_map do |machine|
  result = solve_system(*[
    machine[:a][0],
    machine[:b][0],
    machine[:a][1],
    machine[:b][1],
    machine[:prize][0],
    machine[:prize][1]
  ].map(&:to_f))
  next nil if result.nil?
  a, b = result
  next nil if a.to_i != a || b.to_i != b
  ((a * 3) + b).to_i
end.sum

p total
