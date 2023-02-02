data = File.read('16.txt').chomp

message = data.chars.map { |char| char.to_i(16).to_s(2).rjust(4, '0') }.join.chars.map(&:to_i)

# part 1

@version_total = 0

def parse_message(msg, num_limit)
  1.upto(num_limit || Float::INFINITY) do
    break if !msg || msg.empty? || msg.all? { |cell| cell == 0 }
    version = msg.shift(3).join.to_i(2)
    type_id = msg.shift(3).join.to_i(2)
    @version_total += version
    if type_id == 4
      literal = ''
      loop do
        bits = msg.shift(5)
        literal << bits[1..4].join
        break if bits[0] == 0
      end
    else
      length_type_id = msg.shift
      if length_type_id == 0
        length_of_subpacket = msg.shift(15).join.to_i(2)
        parse_message(msg.shift(length_of_subpacket), nil)
      else
        number_of_subpackets = msg.shift(11).join.to_i(2)
        parse_message(msg, number_of_subpackets)
      end

    end
  end
end

parse_message(message.dup, nil)
p @version_total


# part 2

def parse_message_2(msg, num_limit)
  values = []
  1.upto(num_limit || Float::INFINITY) do
    break if !msg || msg.empty? || msg.all? { |cell| cell == 0 }
    version = msg.shift(3).join.to_i(2)
    type_id = msg.shift(3).join.to_i(2)
    # p "v: #{version}, t:#{type_id}"
    # p msg.join
    if type_id == 4
      literal = ''
      loop do
        bits = msg.shift(5)
        literal << bits[1..4].join
        break if bits[0] == 0
      end
      values << literal.to_i(2)
    else
      length_type_id = msg.shift
      sub_values = []
      if length_type_id == 0
        length_of_subpacket = msg.shift(15).join.to_i(2)
        sub_values = parse_message_2(msg.shift(length_of_subpacket), nil)
      else
        number_of_subpackets = msg.shift(11).join.to_i(2)
        sub_values = parse_message_2(msg, number_of_subpackets)
      end
      case type_id
      when 0
        values << sub_values.sum
      when 1
        values << sub_values.inject(&:*)
      when 2
        values << sub_values.min
      when 3
        values << sub_values.max
      when 5
        values << (sub_values[0] > sub_values[1] ? 1 : 0)
      when 6
        values << (sub_values[0] < sub_values[1] ? 1 : 0)
      when 7
        values << (sub_values[0] == sub_values[1] ? 1 : 0)
      end
    end
  end
  values
end

p parse_message_2(message, nil)[0]
