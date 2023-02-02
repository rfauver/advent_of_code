# part 1
data = File.read('/Users/rfauver/Desktop/data14.txt').split("\n");

mem = {}
mask = ''

data.each do |line|
  next eval(line) if line.start_with?('mask')
  address, num = line.match(/(\d+)\] = (\d+)/).captures
  binary_string = num.to_i.to_s(2).rjust(36, '0')
  mem[address] = mask.each_char.map.with_index do |char, i|
    char != 'X' ? char : binary_string[i]
  end.join.to_i(2)
end;

mem.values.sum


# part 2

data = File.read('/Users/rfauver/Desktop/data14.txt').split("\n");

mem = {}
mask = ''

data.each do |line|
  next eval(line) if line.start_with?('mask')
  address, num = line.match(/(\d+)\] = (\d+)/).captures
  binary_address = address.to_i.to_s(2).rjust(36, '0')

  changed = mask.each_char.map.with_index do |char, i|
    char == '0' ? binary_address[i] : char
  end.join
  xes = changed.count('X')
  (2 ** xes).times.map do |i|
    i.to_s(2).rjust(xes, '0').chars.reduce(changed) { |chnged, replacement| chnged.sub('X', replacement) }.to_i(2)
  end.each do |addr|
    mem[addr] = num.to_i
  end
end;

mem.values.sum
