data = File.read('17.txt').chomp

match_data = data.match(/x=([0-9-]+\.\.[0-9-]+), y=([0-9-]+\.\.[0-9-]+)/)

@x_min, @x_max = match_data[1].split('..').map(&:to_i)
@y_min, @y_max = match_data[2].split('..').map(&:to_i)


def launch(x_vel, y_vel)
  # debug = x_vel === 6 && y_vel == 9
  i = 0
  curr_x = 0
  curr_y = 0
  max_height = curr_y
  curr_x_vel = x_vel
  curr_y_vel = y_vel
  # dist_from_x = [(@x_min - curr_x).abs, (@x_max - curr_x).abs].min
  dist_below_y = @y_min - curr_y
  # last_dist_from_x = dist_from_x + 1
  missed = false
  until (curr_x >= @x_min && curr_x <= @x_max) && (curr_y >= @y_min && curr_y <= @y_max)
    curr_x += curr_x_vel
    curr_y += curr_y_vel
    # puts "#{curr_x}, #{curr_y}" if debug
    if curr_x_vel > 0
      curr_x_vel -= 1
    elsif curr_x_vel < 0
      curr_x_vel += 1
    end
    curr_y_vel -= 1
    i += 1
    max_height = curr_y if curr_y > max_height
    # dist_from_x = [(@x_min - curr_x).abs, (@x_max - curr_x).abs].min
    dist_below_y = @y_min - curr_y
    # p dist_from_x if debug
    # if last_dist_from_x <= dist_from_x || dist_below_y > 0
    if dist_below_y > 0
      missed = true
      break
    end
    # last_dist_from_x = dist_from_x
  end
  missed ? nil : max_height
end
# part 1


results = []
0.upto(@x_min) do |x|
  0.upto(100) do |y|
    result = launch(x, y)
    # puts "#{x}, #{y}: #{result}"
    results << result
  end
end
# p results.compact
p results.compact.max

# part 2

results = []
0.upto(@x_max) do |x|
  -100.upto(100) do |y|
    result = launch(x, y)
    # puts "#{x}, #{y}: #{result}"
    results << result
  end
end
p results.compact.length
