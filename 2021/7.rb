data = File.read('7.txt', chomp: true).split(',').map(&:to_i)

# part 1

min, max = data.minmax

min_fuel_cost = Float::INFINITY

min.upto(max) do |i|
  fuel_cost = data.sum { |crab| (crab - i).abs }
  min_fuel_cost = fuel_cost if fuel_cost < min_fuel_cost
end

p min_fuel_cost


# part 2

min, max = data.minmax

min_fuel_cost = Float::INFINITY

min.upto(max) do |i|
  fuel_cost = data.sum { |crab| (1..(crab - i).abs).sum }
  min_fuel_cost = fuel_cost if fuel_cost < min_fuel_cost
end

p min_fuel_cost

