data = File.readlines('1.txt', chomp: true).map(&:to_i)

# part 1
puts data.each_cons(2).count { |x, y| y > x }

# part 2
puts data.each_cons(3).map(&:sum).each_cons(2).count { |x, y| y > x }
