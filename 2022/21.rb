@monkeys = File.readlines('21.txt', chomp: true).map do |monkey|
  name, formula = monkey.split(': ')
  converted = {}
  if formula.match(/\d+/)
    converted[:value] = formula.to_i
  else
    first,operator,second = formula.split(' ')
    converted[:first] = first.to_sym
    converted[:operator] = operator
    converted[:second] = second.to_sym
  end
  [name.to_sym, converted]
end.to_h

# p monkeys

def get_value(monkey)
  return monkey[:value] if monkey.key?(:value)

  computed = eval("#{get_value(@monkeys[monkey[:first]])}#{monkey[:operator]}#{get_value(@monkeys[monkey[:second]])}")
  monkey[:value] = computed
  computed
end

p get_value(@monkeys[:root])

# part 2

@monkeys = File.readlines('21.txt', chomp: true).map do |monkey|
  name, formula = monkey.split(': ')
  converted = { name: name.to_sym }
  if formula.match(/\d+/)
    converted[:value] = formula.to_i
  else
    first,operator,second = formula.split(' ')
    converted[:first] = first.to_sym
    converted[:operator] = name == 'root' ? '==' : operator
    converted[:second] = second.to_sym
  end
  [name.to_sym, converted]
end.to_h

# p monkeys

def get_value(monkey)
  return monkey[:name].to_s if monkey[:name] == :humn
  return monkey[:value].to_s if monkey.key?(:value)
  first = get_value(@monkeys[monkey[:first]])
  second = get_value(@monkeys[monkey[:second]])
  if first.include?('humn') || second.include?('humn')
    include_parens = monkey[:operator] != '=='
    computed = "#{include_parens ? '(' : ''}#{first}#{monkey[:operator]}#{second}#{include_parens ? ')' : ''}"
  else
    computed = eval("#{first}#{monkey[:operator]}#{second}").to_s
  end

  # p computed
  monkey[:value] = computed
  computed
end

formula = get_value(@monkeys[:root])
p formula

