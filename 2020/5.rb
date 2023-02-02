# part 1

data = File.read('/Users/rfauver/Desktop/data5.txt').split;

data.map do |pass|
  row = pass[0...7].gsub('B', '1').gsub('F', '0').to_i(2)
  seat = pass[-3..-1].gsub('R', '1').gsub('L', '0').to_i(2)
  (row * 8) + seat
end.max


# part 2

sorted = data.map do |pass|
  row = pass[0...7].gsub('B', '1').gsub('F', '0').to_i(2)
  seat = pass[-3..-1].gsub('R', '1').gsub('L', '0').to_i(2)
  (row * 8) + seat
end.sort
x = sorted.first

sorted.each do |pass|
  break x if x != pass
  x += 1
end
