# part 1

data = File.read('/Users/rfauver/Desktop/data10.txt').split.map(&:to_i);
sorted = data.sort;

one = 0
two = 0
three = 0

sorted.each_with_index do |jolt, i|
  prev = i == 0 ? 0 : sorted[i-1]
  one += 1 if jolt - prev == 1
  two += 1 if jolt - prev == 2
  three += 1 if jolt - prev == 3
end;

(three+1) * one


# part 2

grp_size = 1
groups = []

@found = [1,1]
def fib(n)
  return @found[n] if @found[n]
  @found[n] = fib(n-1) + fib(n-2)
  @found[n]
end

sorted.each_with_index do |jolt, i|
  prev = i == 0 ? 0 : sorted[i-1]
  if jolt - prev == 3
    groups << grp_size
    grp_size = 1
  else
    grp_size += 1
  end
end
groups << grp_size

groups.select { |size| size > 2 }.map { |size| fib(size) - 1 }.reduce(&:*)

# alternative---

def get_counts(i, sorted)
  return 1 if i == sorted.length - 1
  (1..3).map do |distance|
    next unless sorted[i+distance]
    get_counts(i+distance, sorted) if sorted[i+distance] - sorted[i] <= 3
  end.compact.sum
end

