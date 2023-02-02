data = eval(File.read('/Users/rfauver/Desktop/data7.txt'));

to_search = ['shiny gold']
finished = []
total = []


while (to_search - finished).length > 0
  to_search.uniq!
  found = data.select do |bag|
    bag[:in].any? { |inner| to_search.include?(inner[2..-1]) }
  end.map { |x| x[:out] }
  found.uniq!
  finished = to_search
  to_search = found
  total += found
end

total.uniq.count

def count_bags(data, to_find, num)
  data.find { |bag| bag[:out] == to_find }[:in].map do |bag|
    count_bags(data, bag[2..-1], bag.to_i) + bag.to_i
  end.sum * num
end

count_bags(data, 'shiny gold', 1)
