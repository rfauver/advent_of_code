# part 1
tickets = File.read('/Users/rfauver/Desktop/data16.txt').split("\n").map { |t| t.split(',').map(&:to_i) };
values = tickets.reduce(&:+);

rules = {
  departure_location:[45..309,320..962],
  departure_station:[27..873,895..952],
  departure_platform:[45..675,687..962],
  departure_track:[42..142,164..962],
  departure_date:[38..433,447..963],
  departure_time:[39..703,709..952],
  arrival_location:[34..362,383..963],
  arrival_station:[26..921,934..954],
  arrival_platform:[38..456,480..968],
  arrival_track:[42..295,310..956],
  class:[29..544,550..950],
  duration:[44..725,749..963],
  price:[37..494,509..957],
  route:[25..170,179..966],
  row:[32..789,795..955],
  seat:[29..98,122..967],
  train:[45..403,418..956],
  type:[36..81,92..959],
  wagon:[25..686,692..955],
  zone:[37..338,353..960],
}

values.select do |value|
  !rules.any? { |field, ranges| ranges.any? { |range| range.include?(value) } }
end.sum


# part 2

valid_tickets = tickets.reject do |ticket|
  ticket.any? { |value| !rules.any? { |field, ranges| ranges.any? { |range| range.include?(value) } } }
end;

possible_fields = (0...tickets.first.length).map do |i|
  rules.select do |field, ranges|
    valid_tickets.map { |t| t[i] }.all? do |value|
      ranges.any? { |range| range.include?(value) }
    end
  end.keys
end;

field_order = []

while field_order.compact.length != possible_fields.length
  only_one_index = possible_fields.find_index { |field_list| field_list.length == 1 }
  only_one_value = possible_fields[only_one_index].first
  field_order[only_one_index] = only_one_value
  possible_fields.each { |field_list| field_list.delete(only_one_value) }
end

my_ticket = [79,193,53,97,137,179,131,73,191,139,197,181,67,71,211,199,167,61,59,127]

my_ticket.select.with_index { |value, i| field_order[i].start_with?('departure') }.inject(&:*)
