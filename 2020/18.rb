# part 1

lines = File.read('/Users/rfauver/Desktop/data18.txt').split("\n");

def find_closing(start_i, str)
  count = 0
  str.each_char.with_index do |char, i|
    next if i < start_i
    case char
    when '('
      count += 1
    when ')'
      return i if count == 0
      count -= 1
    end
  end
end

def eval_line(line)
  expr = ['']
  i = 0
  while i < line.length
    case line[i]
    when /\d/
      expr.last << line[i]
    when '('
      closing_index = find_closing(i+1, line)
      expr.last << eval_line(line[(i+1)...closing_index]).to_s
      i = closing_index
    when '+', '*'
      expr << line[i]
    end
    i += 1
  end
  expr.reduce(0) do |total, part|
    operator, num = part.match(/(\+|\*)?(\d+)/).captures
    next num.to_i unless operator
    [total, num.to_i].reduce(&operator.to_sym)
  end
end

lines.sum do |line|
  eval_line(line)
end


# part 2

def eval_line_2(line)
  expr = ['']
  i = 0
  while i < line.length
    case line[i]
    when /\d/
      expr.last << line[i]
    when '('
      closing_index = find_closing(i+1, line)
      expr.last << eval_line_2(line[(i+1)...closing_index]).to_s
      i = closing_index
    when '+', '*'
      expr << line[i]
    end
    i += 1
  end
  expr.join.split('*').map { |str| eval(str) }.reduce(&:*)
end

lines.sum do |line|
  eval_line_2(line)
end
