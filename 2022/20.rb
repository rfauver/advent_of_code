data = File.readlines('20.txt', chomp: true).map(&:to_i)

original = data.clone
modified = data.clone.map.with_index { |val, i| [val,i] }

original.each_with_index do |dist, i|
  p [i, modified.length]
  # p modified.map(&:first)
  next if dist == 0
  curr_i = modified.find_index { |(_,j)| i == j }
  prev = modified[curr_i]
  destination = curr_i + dist
  destination = (destination%original.length + destination/modified.length) % (modified.length - 1)
  destination = modified.length - 1 if destination == 0

  modified[curr_i] = :old
  if destination < curr_i
    modified = modified[0...destination] + [prev] + modified[destination..-1]
  else
    modified = modified[0..destination] + [prev] + modified[destination+1..-1]
  end
  modified.delete(:old)
end

# p modified.map(&:first)

vals = 1.upto(3).map do |x|
  modified[(modified.index { |(val,_)| val == 0 } + (x*1000))%modified.length].first
end

# p vals

p vals.sum

# part 2

descryption_key = 811589153

data = File.readlines('20.txt', chomp: true).map { |num| num.to_i * descryption_key }

original = data.clone
modified = data.clone.map.with_index { |val, i| [val,i] }

10.times do
  original.each_with_index do |dist, i|
    p [i, modified.length] if i%100==0
    # p modified.map(&:first)
    next if dist == 0
    curr_i = modified.find_index { |(_,j)| i == j }
    prev = modified[curr_i]
    destination = curr_i + dist
    destination = (destination%original.length + destination/modified.length) % (modified.length - 1)
    destination = modified.length - 1 if destination == 0

    modified[curr_i] = :old
    if destination < curr_i
      modified = modified[0...destination] + [prev] + modified[destination..-1]
    else
      modified = modified[0..destination] + [prev] + modified[destination+1..-1]
    end
    modified.delete(:old)
  end
end

# p modified.map(&:first)

vals = 1.upto(3).map do |x|
  modified[(modified.index { |(val,_)| val == 0 } + (x*1000))%modified.length].first
end

p vals.sum
