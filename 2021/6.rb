data = File.read('6.txt', chomp: true).split(',').map(&:to_i)

# part 1

fish = data
new_fish = []

80.times do
  fish = fish.map do |age|
    if age == 0
      new_fish << 8
      6
    else
      age - 1
    end
  end
  fish += new_fish
  new_fish = []
end

p fish.size

# part 2

fish = data.tally

256.times do
  new_fish = Hash.new(0)
  reset = 0

  fish.each do |age, count|
    if age == 0
      reset = count
      new_fish[8] = count
    else
      new_fish[age - 1] = count
    end
  end
  new_fish[6] += reset
  fish = new_fish
end

p fish.values.sum
