data = File.read('11.txt', chomp: true)
monkey_data = data.split("\n\n")

# part 1

def generate_monkeys(data)
  data.map do |string|
    items = string.match(/items: (.*)$/)[1].split(', ').map(&:to_i)
    op_string = string.match(/new = (.*)$/)[1]
    operation = proc { |old| eval(op_string) }
    test_factor = string.match(/divisible by (.*)$/)[1].to_i
    true_index = string.match(/true: throw to monkey (.*)$/)[1].to_i
    false_index = string.match(/false: throw to monkey (.*)$/)[1].to_i
    {
      items: items,
      test_factor: test_factor,
      operation: operation,
      true_index: true_index,
      false_index: false_index,
      inspected_count: 0
    }
  end
end

monkeys = generate_monkeys(monkey_data)

20.times do
  monkeys.each do |monkey|
    until monkey[:items].empty?
      monkey[:inspected_count] += 1

      item = monkey[:items].shift
      level = monkey[:operation].call(item)
      level /= 3
      next_index = level % monkey[:test_factor] == 0 ? monkey[:true_index] : monkey[:false_index]
      monkeys[next_index][:items] << level
    end
  end
end

p monkeys.map { |monkey| monkey[:inspected_count] }.max(2).inject(&:*)

# part 2

monkeys = generate_monkeys(monkey_data)
big_mod = monkeys.map { |m| m[:test_factor] }.reduce(&:*)

10_000.times do |i|
  p i if i % 100 == 0
  monkeys.each do |monkey|
    until monkey[:items].empty?
      monkey[:inspected_count] += 1

      item = monkey[:items].shift
      level = monkey[:operation].call(item)
      level %= big_mod
      next_index = level % monkey[:test_factor] == 0 ? monkey[:true_index] : monkey[:false_index]
      monkeys[next_index][:items] << level
    end
  end
end

p monkeys.map { |monkey| monkey[:inspected_count] }.max(2).inject(&:*)
