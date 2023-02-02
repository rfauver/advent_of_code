data = File.read('6.txt', chomp: true)

# part 1

data.chars.each_cons(4).with_index do |set, i|
  if set.uniq.length == set.length
    p i + 4
    break
  end
end

# part 2

data.chars.each_cons(14).with_index do |set, i|
  if set.uniq.length == set.length
    p i + 14
    break
  end
end
