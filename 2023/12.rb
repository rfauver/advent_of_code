data = File.readlines("12.txt", chomp: true)

# part 1

@cache = {}

def options(string)
  return string == "?" ? ["#", "."] : [string] if string.length == 1

  return @cache[string] if @cache[string]

  sub_string = options(string[1..-1])
  res = if string[0] == "?"
    sub_string.map { |str| "#" + str } + sub_string.map { |str| "." + str }
  else
    sub_string.map { |str| string[0] + str }
  end
  @cache[string] = res
  res
end

total = data.map do |line|
  record, sizes = line.split(" ")
  sizes = sizes.split(",").map(&:to_i)

  options(record).filter { |option| option.scan(/[\?#]+/).map(&:length) == sizes }.count
end.sum

p total

# part 2

@cache_2 = {}

def valid?(str, len)
  str.count(".") == 0 && str.length >= len
end

def options_2(str, sizes)
  return @cache_2[[str, sizes]] if @cache_2[[str, sizes]]
  hash_count = str&.count("#") || 0
  return 0 if hash_count > sizes.sum
  return hash_count == 0 ? 1 : 0 if sizes.length == 0
  return 0 if str.nil? || str.length == 0
  if sizes.length == 1
    if str.length < sizes.first
      return 0
    elsif str.length == sizes.first
      return valid?(str, sizes.first) && str[sizes.first] != "#" ? 1 : 0
    end
  end

  if str[0] == "#"
    if valid?(str[0...(sizes.first)], sizes.first) && str[sizes.first] != "#"
      return options_2(str[(sizes.first+1)..-1], sizes[1..-1])
    else
      return 0
    end
  end

  total = if valid?(str[0...(sizes.first)], sizes.first) && str[sizes.first] != "#"
    options_2(str[(sizes.first+1)..-1], sizes[1..-1]) + options_2(str[1..-1], sizes)
  else
    options_2(str[1..-1], sizes)
  end
  @cache_2[[str, sizes]] = total
  total
end


total = data.map.with_index do |line, j|
  record, sizes = line.split(" ")
  sizes = sizes.split(",").map(&:to_i)
  record = 5.times.map { record }.join("?")
  sizes = 5.times.map { sizes }.flatten

  options_2(record, sizes)
end.sum

p total
