# part 1
depart = 1000066
buses = %w[13 x x 41 x x x 37 x x x x x 659 x x x x x x x x x x x x x x x x x x 19 x x x 23 x x x x x 29 x 409 x x x x x x x x x x x x x x x x 17];

(0..).each do |offset|
  found = buses.select { |b| b != 'x' }.map(&:to_i).sort.each do |b|
    break b if (offset + depart) % b == 0
  end
  break offset * found if found.kind_of?(Integer)
end

# part 2

check = 1
jmp = 1
so_far = -1
loop do
  p check
  break check if buses.each_with_index.all? do |b, i|
    next true if b == 'x'
    if (check + i) % b.to_i == 0
      if i > so_far
        so_far = i
        jmp = buses[0..i].select { |b| b != 'x' }.map(&:to_i).inject(&:*)
        p '-----------------'
      end
      true
    end
  end
  check += jmp
end
