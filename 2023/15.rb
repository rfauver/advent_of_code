data = File.read("15.txt").chomp.split(",")

# part 1

def hash(str)
  str.chars.reduce(0) { |val, char| ((val + char.codepoints.first) * 17) % 256 }
end

p data.sum { |str| hash(str) }

# part 2

boxes = Array.new(256) { [] }

data.each do |str|
  if str.end_with?('-')
    label = str[0..-2]
    box = hash(label)
    boxes[box].delete_if { |lens| lens[:label] == label }
  else
    label, focal_length = str.split("=")
    box = hash(label)
    found_lens_index = boxes[box].find_index { |lens| lens[:label] == label }
    if found_lens_index
      boxes[box][found_lens_index] = { label: label, focal_length: focal_length.to_i }
    else
      boxes[box].push({ label: label, focal_length: focal_length.to_i })
    end
  end
end

total = boxes.map.with_index do |box, i|
  next 0 if box.length == 0

  box.map.with_index { |lens, j| (i + 1) * (j + 1) * lens[:focal_length] }.sum
end.sum

p total
