file_data = File.read('/Users/rfauver/Desktop/data.txt')
data = eval(file_data);

data.count do |datum|
  datum[:rng].include?(datum[:pwd].chars.count { |char| char == datum[:ltr] })
end


data.count do |datum|
  (datum[:pwd][datum[:rng].first - 1] == datum[:ltr]) ^ (datum[:pwd][datum[:rng].last - 1] == datum[:ltr])
end

