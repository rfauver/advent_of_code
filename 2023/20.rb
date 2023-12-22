data = File.readlines("20.txt", chomp: true)

class FlipFlop
  def initialize
    @on = false
  end

  def send_pulse(pulse, _)
    return if pulse == :high

    @on = !@on
    @on ? :high : :low
  end

  def inspect
    "<FlipFlop on: #{@on.inspect}>"
  end
end

class Conjunction
  attr_accessor :inputs

  def initialize
    @inputs = nil
  end

  def send_pulse(pulse, input)
    @inputs[input] = pulse
    @inputs.values.all? { |val| val == :high } ? :low : :high
  end

  def inspect
    "<Conjunction inputs: #{@inputs.inspect}>"
  end
end

class Broadcast
  def send_pulse(pulse, _)
    pulse
  end

  def inspect
    "<Broadcast>"
  end
end

# part 1

modules = {}

data.each do |line|
  mod, outputs = line.split(" -> ")
  outputs = outputs.split(", ")
  if mod == "broadcaster"
    modules["broadcaster"] = { mod: Broadcast.new, outputs: outputs }
  elsif mod.start_with?("%")
    modules[mod[1..-1]] = { mod: FlipFlop.new, outputs: outputs }
  else
    modules[mod[1..-1]] = { mod: Conjunction.new, outputs: outputs }
  end
end

modules.filter { |name, val| val[:mod].is_a?(Conjunction) }.each do |name, val|
  val[:mod].inputs = modules.filter { |_, val2| val2[:outputs].include?(name) }.map { |name2, _| [name2, :low] }.to_h
end

# p modules

low_count = 0
high_count = 0

1000.times do
  next_pulses = [["broadcaster", :low, nil]]

  until next_pulses.empty?

    name, pulse, from = next_pulses.shift
    low_count += 1 if pulse == :low
    high_count += 1 if pulse == :high
    next_mod = modules[name]
    next if next_mod.nil?

    new_pulse = next_mod[:mod].send_pulse(pulse, from)

    next if new_pulse.nil?
    next_mod[:outputs].each do |output|
      # puts "#{name} -#{new_pulse}> #{output}"
      next_pulses << [output, new_pulse, name]
    end
  end
end

p low_count * high_count

# part 2

modules = {}

data.each do |line|
  mod, outputs = line.split(" -> ")
  outputs = outputs.split(", ")
  if mod == "broadcaster"
    modules["broadcaster"] = { mod: Broadcast.new, outputs: outputs }
  elsif mod.start_with?("%")
    modules[mod[1..-1]] = { mod: FlipFlop.new, outputs: outputs }
  else
    modules[mod[1..-1]] = { mod: Conjunction.new, outputs: outputs }
  end
end

modules.filter { |name, val| val[:mod].is_a?(Conjunction) }.each do |name, val|
  val[:mod].inputs = modules.filter { |_, val2| val2[:outputs].include?(name) }.map { |name2, _| [name2, :low] }.to_h
end

button_count = 0
last_module = modules.find { |name, val| val[:outputs].include?("rx") }.first
last_input_cycles = modules[last_module][:mod].inputs.map { |(k, _)| [k, nil] }.to_h

while last_input_cycles.any? { |k,v| v.nil? }
  button_count += 1

  next_pulses = [["broadcaster", :low, nil]]

  until next_pulses.empty?

    name, pulse, from = next_pulses.shift
    if name == "rx" && pulse == :low
      p button_count
      exit
    end
    low_count += 1 if pulse == :low
    high_count += 1 if pulse == :high
    next_mod = modules[name]
    next if next_mod.nil?

    new_pulse = next_mod[:mod].send_pulse(pulse, from)

    next if new_pulse.nil?
    next_mod[:outputs].each do |output|
      if output == "rx"
        inputs = modules[name][:mod].inputs
        found = inputs.find { |_, val| val == :high }
        last_input_cycles[found.first] = button_count if found
      end

      next_pulses << [output, new_pulse, name]
    end
  end
end

p last_input_cycles.values.inject(:lcm)

