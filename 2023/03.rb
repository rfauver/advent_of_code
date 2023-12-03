data = File.readlines("03.txt", chomp: true).map { |line| ".#{line}."}

syms = ["@", "*", "/", "+", "$", "=", "&", "-", "#", "%"]
total = 0
data.each_with_index do |line, y|
  numbers = line.scan(/\d+/)
  last_num = ""
  last_i = nil

  numbers.each do |num|
    i = line.index(Regexp.new("\\D#{num}\\D")) + 1
    if last_i && last_num
      i = line[(last_i + last_num.length)..-1].index(Regexp.new("\\D#{num}\\D")) + 1 + last_i + last_num.length
    end
    last_i = i
    last_num = num

    before_line = data[y-1] && data[y-1].chars[(i-1)..(i+num.length)].any? { |char| syms.include?(char) }
    after_line = data[y+1] && data[y+1].chars[(i-1)..(i+num.length)].any? { |char| syms.include?(char) }
    symbols = syms.include?(line[i-1]) || syms.include?(line[i+num.length]) || before_line || after_line
    total += num.to_i if symbols
  end
end

p total

# part 2

potential_gears = Hash.new { |h, k| h[k] = [] }
data.each_with_index do |line, y|
  numbers = line.scan(/\d+/)
  last_num = ""
  last_i = nil

  numbers.each do |num|
    i = line.index(Regexp.new("\\D#{num}\\D")) + 1
    if last_i && last_num
      i = line[(last_i + last_num.length)..-1].index(Regexp.new("\\D#{num}\\D")) + 1 + last_i + last_num.length
    end
    last_i = i
    last_num = num

    potential_gears[[i-1, y]] << num if line[i-1] == "*"
    potential_gears[[i+num.length, y]] << num if line[i+num.length] == "*"

    if data[y-1]
      data[y-1].chars[(i-1)..(i+num.length)].each_with_index do |char, j|
        potential_gears[[i-1+j, y-1]] << num if char == "*"
      end
    end
    if data[y+1]
      data[y+1].chars[(i-1)..(i+num.length)].each_with_index do |char, j|
        potential_gears[[i-1+j, y+1]] << num if char == "*"
      end
    end
  end
end

p potential_gears.values.select { |gears| gears.length == 2 }.map { |gears| gears.map(&:to_i).reduce(&:*) }.sum
