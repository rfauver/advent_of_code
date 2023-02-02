# part 1

starting_order = [9,5,2,3,1,6,4,8,7]

cups = starting_order.dup
100.times do
  starting_cur = cups.first
  pick_up = cups.slice!(1..+3)
  destination = cups.first - 1
  until cups.include?(destination)
    destination -= 1
    destination = cups.max if destination <= 0
  end
  dest_i = cups.find_index(destination)
  cups.insert(dest_i+1, *pick_up)

  cups.rotate! until cups.first == starting_cur

  cups.rotate!
end

cups.rotate! until cups.first == 1
cups[1..-1].join


# part 2

starting_order = 1.upto(1_000_000).map { |i| i };
starting_order[0,9] = [9,5,2,3,1,6,4,8,7];

cups = starting_order.each_with_index.to_h { |c, i| [c, starting_order[i+1]]};
cups[starting_order.length] = starting_order.first;

cur = cups.keys.first
10_000_000.times do |i|
  puts i if i % 100_000 == 0
  pick_up = [cups[cur], cups[cups[cur]], cups[cups[cups[cur]]]]
  cups[cur] = cups[pick_up.last]
  pick_up.each { |cup| cups[cup] = nil }

  destination = cur - 1
  until cups[destination]
    destination -= 1
    destination = cups.values.compact.max if destination <= 0
  end

  after_destination = cups[destination]
  cups[destination] = pick_up[0]
  cups[pick_up[0]] = pick_up[1]
  cups[pick_up[1]] = pick_up[2]
  cups[pick_up[2]] = after_destination

  cur = cups[cur]
end

cups_of_one = cups[1]
cups_of_one * cups[cups_of_one]
