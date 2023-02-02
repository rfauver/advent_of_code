# part 1

data = File.read('/Users/rfauver/Desktop/data9.txt').split.map(&:to_i);
size = 25

(size..).each do |i|
  break data[i] unless data[(i-size)...i].combination(2).any? { |comb| comb.sum == data[i] }
end


# part 2

total = 27911108 # total from part 1
(2..1000).each do |range_size|
  found = data.each_cons(range_size) do |range|
    break (range.min + range.max) if range.sum == total
  end
  break found if found
end
