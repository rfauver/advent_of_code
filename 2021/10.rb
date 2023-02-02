data = File.readlines('10.txt', chomp: true)

# part 1

pairs = { ')' => '(', ']' => '[', '}' => '{', '>' => '<' }

incorrects = data.map do |line|
  stack = []
  incorrect = nil
  line.each_char do |char|
    case char
    when '(', '[', '{', '<'
      stack.push(char)
    when ')', ']', '}', '>'
      if pairs[char] != stack.pop
        incorrect = char
        break
      end
    end
  end
  incorrect
end

p (incorrects.compact.sum do |char|
  { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }[char]
end)

# part 2

scores = data.map do |line|
  stack = []
  incorrect = nil
  line.each_char do |char|
    case char
    when '(', '[', '{', '<'
      stack.push(char)
    when ')', ']', '}', '>'
      if pairs[char] != stack.pop
        incorrect = char
        break
      end
    end
  end
  next nil if incorrect

  score = 0
  until stack.empty?
    char = stack.pop
    score = score * 5 + { '(' => 1, '[' =>  2, '{' =>  3, '<' => 4 }[char]
  end

  score
end.compact

p scores.sort[scores.size/2]
