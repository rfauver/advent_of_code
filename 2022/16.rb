data = File.readlines('16.txt', chomp: true)

valves = data.map do |line|
  id = line.match(/^Valve (..)/)[1]
  rate = line.match(/rate=(\d+);/)[1].to_i
  neighbors = line.match(/valves? (.*)$/)[1].split(', ')

  [id, { id: id, rate: rate, neighbors: neighbors }]
end.to_h

with_flow = valves.keys.select { |id| valves[id][:rate] > 0 }

def djikstra(vertices, startId)
  distances = {}
  set = []
  vertices.each do |id, valve|
    distances[id] = Float::INFINITY
    set << id
  end
  distances[startId] = 0

  until set.empty?
    curr = set.sort_by! { |id| distances[id] }.shift
    vertices[curr][:neighbors].each do |id|
      next unless set.include?(id)

      distance_from_here = distances[curr] + 1

      if distance_from_here < distances[id]
        distances[id] = distance_from_here
      end
    end
  end

  distances
end

valves = (with_flow + ['AA']).map do |id|
  distances = djikstra(valves, id).select { |key, value| with_flow.include?(key) && key != id }
  [id, valves[id].merge({ distances: distances })]
end.to_h

def compute_value(valves, current, on_list, time_left, stored)
  # p [time_left, on_list.length, current]
  return 0 if time_left <= 0 || on_list.length == valves.length
  computed_already = stored[[current, on_list, time_left].to_s]
  return computed_already if computed_already

  value_if_on = (time_left - 1) * valves[current][:rate]

  best_value = valves[current][:distances].map do |id, dist|
    next 0 unless valves[id]

    dist_to_next = time_left - valves[current][:distances][id]

    turning_on_val = 0
    if !on_list.include?(current)
      turning_on_val = value_if_on + compute_value(valves, id, on_list + [current], dist_to_next - 1, stored)
    end

    leaving_off_val = compute_value(valves, id, on_list, dist_to_next, stored)

    turning_on_val > leaving_off_val ? turning_on_val : leaving_off_val
  end.max

  stored[[current, on_list, time_left].to_s] = best_value
end

# p compute_value(valves, 'AA', [], 30, {})

# part 2

# def compute_value_with_elephant(valves, current_1, current_2, on_list, time_left)
#   # p [time_left, on_list.length, current]
#   return 0 if time_left <= 0 || on_list.length == valves.length
#   computed_already = @stored[[current_1, current_2, on_list, time_left].to_s]
#   return computed_already if computed_already

#   value_if_on_1 = (time_left - 1) * valves[current_1][:rate]

#   best_value = valves[current][:distances].map do |id, dist|
#     dist_to_next = time_left - valves[current][:distances][id]

#     turning_on_val = 0
#     if !on_list.include?(current)
#       turning_on_val = value_if_on + compute_value(valves, id, on_list + [current], dist_to_next - 1)
#     end

#     leaving_off_val = compute_value(valves, id, on_list, dist_to_next)

#     turning_on_val > leaving_off_val ? turning_on_val : leaving_off_val
#   end.max

#   @stored[[current, on_list, time_left].to_s] = best_value
# end


without_start = valves.except('AA')
combos = 1.upto(without_start.length / 2).map do |i|
  without_start.keys.combination(i).map { |combo| [combo, without_start.keys - combo] }
end.flatten(1)

max = combos.map do |(set_1, set_2)|
  p set_1

  val_1 = compute_value(valves.slice(*(set_1 + ['AA'])), 'AA', [], 26, {})
  val_2 = compute_value(valves.slice(*(set_2 + ['AA'])), 'AA', [], 26, {})

  val_1 + val_2
end.max

p max
