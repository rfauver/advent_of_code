boxes = File.readlines("08.txt", chomp: true).map { |box| box.split(",").map(&:to_i) }

# part 1
ordered = boxes.combination(2).map do |(box1, box2)|
  [box1, box2, Math.sqrt((box2[0]-box1[0])**2 + (box2[1]-box1[1])**2 + (box2[2]-box1[2])**2)]
end.sort_by { |(_, _, dist)| dist }

current_key = :a
box_to_key = {}
key_to_boxes = {}

1000.times do |i|
  box1, box2 = ordered[i]
  if box_to_key[box1].nil? && box_to_key[box2].nil?
    box_to_key[box1] = current_key
    box_to_key[box2] = current_key
    key_to_boxes[current_key] = [box1, box2]
    current_key = current_key.next
  elsif box_to_key[box1].nil?
    box_to_key[box1] = box_to_key[box2]
    key_to_boxes[box_to_key[box2]] << box1
  elsif box_to_key[box2].nil?
    box_to_key[box2] = box_to_key[box1]
    key_to_boxes[box_to_key[box1]] << box2
  elsif box_to_key[box1] != box_to_key[box2]
    boxes_to_update = key_to_boxes[box_to_key[box1]]
    key_to_boxes.delete(box_to_key[box1])
    boxes_to_update.each do |to_update|
      box_to_key[to_update] = box_to_key[box2]
      key_to_boxes[box_to_key[box2]] << to_update
    end
  end
end

p key_to_boxes.map { |_, boxes| boxes.length }.sort.last(3).inject(&:*)

# part 2
current_key = :a
box_to_key = {}
key_to_boxes = {}
wired_count = 0

last_added = ordered.each do |(box1, box2)|
  if box_to_key[box1].nil? && box_to_key[box2].nil?
    box_to_key[box1] = current_key
    box_to_key[box2] = current_key
    key_to_boxes[current_key] = [box1, box2]
    current_key = current_key.next
    wired_count += 2
  elsif box_to_key[box1].nil?
    box_to_key[box1] = box_to_key[box2]
    key_to_boxes[box_to_key[box2]] << box1
    wired_count += 1
  elsif box_to_key[box2].nil?
    box_to_key[box2] = box_to_key[box1]
    key_to_boxes[box_to_key[box1]] << box2
    wired_count += 1
  elsif box_to_key[box1] != box_to_key[box2]
    boxes_to_update = key_to_boxes[box_to_key[box1]]
    key_to_boxes.delete(box_to_key[box1])
    boxes_to_update.each do |to_update|
      box_to_key[to_update] = box_to_key[box2]
      key_to_boxes[box_to_key[box2]] << to_update
    end
  end

  break [box1, box2] if wired_count == boxes.length
end

p last_added[0][0] * last_added[1][0]
