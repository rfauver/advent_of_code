data = File.read('13.txt', chomp: true)

# part 1

pairs = data.split("\n\n").map { |pair| pair.split("\n").map { |list| eval(list) } }

def compare_lists(first, second)
  return true if first == [] && second != []
  first.each_with_index do |left, i|
    right = second[i]
    # puts "left: >#{left}<, right: >#{right}<"
    return false if right.nil?

    if left.kind_of?(Integer)
      if second[i].kind_of?(Integer)
        return false if left > right
        return true if left < right
      else
        result = compare_lists([left], right)
        return result unless result.nil?
      end
    else
      if right.kind_of?(Integer)
        result = compare_lists(left, [right])
        return result unless result.nil?
      else
        result = compare_lists(left, right)
        return result unless result.nil?
      end
    end
  end
  return true if first.length < second.length
  nil
end

puts (pairs.map.with_index do |(first, second), i|
  result = compare_lists(first, second)
  result.nil? || result ? i+1 : 0
end.sum)


# part 2

list = pairs.flatten(1)

list << [[2]]
list << [[6]]

sorted = list.sort do |a, b|
  result = compare_lists(a, b)
  result.nil? || result ? -1 : 1
end

p (sorted.find_index([[2]]) + 1) * (sorted.find_index([[6]]) + 1)
