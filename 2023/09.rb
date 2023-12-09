data = File.readlines("09.txt", chomp: true).map { |line| line.split(" ").map(&:to_i) }

# part 1

def next_val(arr)
  diffs = arr.each_cons(2).map { |(a,b)| b - a }
  (diffs.uniq.length == 1 ? diffs.last : next_val(diffs)) + arr.last
end

p data.map { |line| next_val(line) }.sum

# part 2

def prev_val(arr)
  diffs = arr.each_cons(2).map { |(a,b)| b - a }
  arr.first - (diffs.uniq.length == 1 ? diffs.first : prev_val(diffs))
end

p data.map { |line| prev_val(line) }.sum
