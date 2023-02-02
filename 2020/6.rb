# part 1
data = File.read('/Users/rfauver/Desktop/data6.txt').split("\n");

data.reduce(['']) do |answers, line|
  next (answers << '') if line == ''
  answers.last << line
  answers
end.sum { |answ| answ.chars.uniq.count }


# part 2

data.reduce([[]]) do |answers, line|
  next (answers << []) if line == ''
  answers.last << line
  answers
end.sum { |answs| answs.map(&:chars).reduce(&:&).count }
