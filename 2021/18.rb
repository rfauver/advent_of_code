data = File.readlines('18.txt', chomp: true)

# part 1

def normalize(str)
  normalized = []
  str.each_char.with_index do |char, i|
    case char
    when /\d/
      if str[i-1].match?(/\d/)
        normalized << (str[i-1] + char).to_i
      elsif !str[i+1].match?(/\d/)
        normalized << char.to_i
      end
    when ','
    else
      normalized << char
    end
  end
  normalized
end

def array_to_s(array)
  array.map do |item|
    item.kind_of?(Integer) ? "#{item}," : (item == ']' ? '],' : item)
  end.join[0..-2]
end

def print_arr(array)
  puts array_to_s(array)
end

def magnitude(array)
  return array if array.kind_of?(Integer)

  (magnitude(array.first) * 3) + (magnitude(array.last) * 2)
end

def sum_fish(list)
  result = list.reduce(nil) do |memo, line|
    normalized = normalize(line)
    # p normalized
    next normalized unless memo

    array =  ['[', *memo, *normalized, ']']

    explode_i = 'start'
    split_i = 'start'

    until explode_i.nil? && split_i.nil?
      stack_count = 0
      explode_i = nil
      split_i = nil

      array.each_with_index do |item, i|
        case item
        when '['
          stack_count += 1
        when ']'
          stack_count -= 1
        end
        if stack_count == 5
          explode_i = i
          break
        end
      end

      if explode_i
        # puts "explode #{explode_i}"
        (explode_i-1).downto(0) do |search_i|
          if array[search_i].kind_of?(Integer)
            array[search_i] = array[search_i] + array[explode_i+1]
            break
          end
        end
        (explode_i+4).upto(array.length-1) do |search_i|
          if array[search_i].kind_of?(Integer)
            array[search_i] = array[search_i] + array[explode_i+2]
            break
          end
        end
        array = array[0..(explode_i-1)] + [0] + array[(explode_i+4)..-1]
        next
      end

      array.each_with_index do |item, i|
        case item
        when Integer
          if item > 9
            split_i = i
            break
          end
        end
      end

      if split_i
        half = array[split_i] / 2.0
        array = array[0..(split_i-1)] + ['[', half.floor, half.ceil, ']'] + array[(split_i+1)..-1]
      end
    end

    array
  end

  string_array = array_to_s(result)
  magnitude(eval(string_array))
end

puts sum_fish(data)

# part 2

max = 0
data.permutation(2) do |perm|
  total = sum_fish(perm)
  max = total if total > max
end

p max
