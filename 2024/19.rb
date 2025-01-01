data = File.read("19.txt", chomp: true)

towels, patterns = data.split("\n\n")

towels = towels.split(", ")
patterns = patterns.split("\n")

# part 1

regex = Regexp.new("^(#{towels.join("|")})+$")
filtered = patterns.filter { |pattern| pattern.match?(regex) }
p filtered.count

# part 2

@towels = towels

def possibilities(str)
  return 1 if str == ""
  return @seen[str] if @seen[str]

  towels_that_work = @towels.filter { |towel| str.start_with?(towel) }

  return 0 if towels_that_work.length == 0

  total = towels_that_work.sum do |towel|
    possibilities(str[towel.length..-1])
  end
  @seen[str] = total
  total
end

p (filtered.sum do |pattern|
  @seen = {}
  possibilities(pattern)
end)
