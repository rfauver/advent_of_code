data = File.readlines('8.txt', chomp: true)

# data = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"]

# part 1

output_lists = data.map do |line|
  _, outputs = line.split(' | ')
  outputs.split
end

p output_lists.flatten.count { |output| [2, 3, 4, 7].include?(output.length) }


# part 2


input_lists = data.map do |line|
  inputs, _ = line.split(' | ')
  inputs.split
end

segments_to_number = {
  [:top, :top_left, :top_right, :bottom_left, :bottom_right, :bottom].sort => 0,
  [:top_right, :bottom_right].sort => 1,
  [:top, :top_right, :middle, :bottom_left, :bottom].sort => 2,
  [:top, :top_right, :middle, :bottom_right, :bottom].sort => 3,
  [:top_left, :top_right, :middle, :bottom_right].sort => 4,
  [:top, :top_left, :middle, :bottom_right, :bottom].sort => 5,
  [:top, :top_left, :middle, :bottom_left, :bottom_right, :bottom].sort => 6,
  [:top, :top_right, :bottom_right].sort => 7,
  [:top, :top_left, :top_right, :middle, :bottom_left, :bottom_right, :bottom].sort => 8,
  [:top, :top_left, :top_right, :middle, :bottom_right, :bottom].sort => 9,
}


total = input_lists.map.with_index do |inputs, i|
  found = %w[a b c d e f g].permutation(7).find do |combo|
    letter_to_segment = combo.zip([:top, :top_left, :top_right, :middle, :bottom_left, :bottom_right, :bottom]).to_h
    numbers = inputs.map do |input|
      segments = input.chars.map do |char|
        letter_to_segment[char]
      end.sort
      segments_to_number[segments]
    end
    numbers.all? && numbers.sort == (0..9).to_a
  end
  letter_to_segment = found.zip([:top, :top_left, :top_right, :middle, :bottom_left, :bottom_right, :bottom]).to_h
  output_lists[i].map do |output|
    segments = output.chars.map do |char|
      letter_to_segment[char]
    end.sort
    segments_to_number[segments]
  end.join.to_i
end.sum
p total

