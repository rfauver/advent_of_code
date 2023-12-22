data = File.readlines("19.txt", chomp: true)

# part 1

rules = {}
parts = []
seen_blank = false

data.each do |line|
  if line.length == 0
    seen_blank = true
  elsif seen_blank
    parts << eval(line.gsub("=", ":"))
  else
    name, rest = line.split("{")
    rs = rest[0..-2].split(",")
    rs = rs.map do |rule|
      next { to: rule } unless rule.include?(":")

      first, to = rule.split(":")
      first = first.chars
      cat = first.shift
      cond = first.shift
      val = first.join.to_i
      { cat: cat.to_sym, cond: cond.to_sym, val: val, to: to }
    end
    rules[name] = rs
  end
end

accepted = []

parts.each do |part|
  curr = "in"

  while curr != "A" && curr != "R"
    curr_rules = rules[curr]

    curr_rules.each do |rule|
      if rule.keys.length == 1
        curr = rule[:to]
        break
      end

      value = part[rule[:cat]]
      if [value, rule[:val]].inject(rule[:cond])
        curr = rule[:to]
        break
      end
    end
  end

  value = part.keys.map { |key| part[key] }.sum
  if curr == "A"
    accepted << value
  end
end

p accepted.sum

# part 2

min = 1
max = 4000

parts = [{ name: "in", x: min..max, m: min..max, a: min..max, s: min..max }]

accepted = []

until parts.empty?
  part = parts.shift

  if part[:name] == "A"
    accepted << part
    next
  elsif part[:name] == "R"
    next
  end

  rs = rules[part[:name]]

  rs.each do |rule|
    if rule.keys.length == 1
      parts << part.merge({ name: rule[:to] })
      break
    end
    cat_range = part[rule[:cat]]
    if (rule[:cond] == :<)
      if cat_range.end < rule[:val]
        parts << part.merge({ name: rule[:to] })
        break
      elsif cat_range.begin < rule[:val]
        lower_range = (cat_range.begin..(rule[:val]-1))
        upper_range = (rule[:val]..cat_range.end)
        parts << part.merge({ name: rule[:to], rule[:cat] => lower_range })
        part = part.merge(rule[:cat] => upper_range)
      end
    else
      if cat_range.begin > rule[:val]
        parts << part.merge({ name: rule[:to] })
        break
      elsif cat_range.end > rule[:val]
        lower_range = (cat_range.begin..rule[:val])
        upper_range = ((rule[:val]+1)..cat_range.end)
        parts << part.merge({ name: rule[:to], rule[:cat] => upper_range })
        part = part.merge(rule[:cat] => lower_range)
      end
    end
  end
end

p accepted.map { |part| %i[x m a s].map { |cat| part[cat].count }.inject(:*) }.sum
