data = File.read("02.txt", chomp: true)

# part 1
invalids = []
data.split(",").each do |span|
  start, endd = span.split("-").map(&:to_i)
  start.upto(endd) do |num|
    str_num = num.to_s
    invalids << num if str_num[0...str_num.length/2] == str_num[str_num.length/2..]
  end
end
p invalids.sum

# part 2
invalids = []
data.split(",").each do |span|
  start, endd = span.split("-").map(&:to_i)
  start.upto(endd) do |num|
    str_num = num.to_s
    1.upto(str_num.length/2) do |i|
      substr = str_num[0...i]
      if /^(#{substr})+$/.match?(str_num)
        invalids << num
        break
      end
    end
  end
end
p invalids.sum
