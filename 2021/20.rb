data = File.readlines('20.txt', chomp: true)

algo = data.shift
data.shift

# part 1

image = Hash.new('.')
data.each_with_index do |line, y|
  line.each_char.with_index do |pixel, x|
    image[[x,y]] = pixel if pixel == '#'
  end
end


2.times do |i|
  output_image = Hash.new(i%2 == 1 ? '.' : '#')
  min_x, max_x = image.keys.map(&:first).minmax
  min_y, max_y = image.keys.map(&:last).minmax

  (min_x - 2).upto(max_x + 2) do |x|
    (min_y - 2).upto(max_y + 2) do |y|
      reading = ''
      -1.upto(1) do |dy|
        -1.upto(1) do |dx|
          reading << (image[[x+dx, y+dy]] == '#' ? '1' : '0')
        end
      end
      output_pixel = algo[reading.to_i(2)]
      output_image[[x,y]] = output_pixel
    end
  end

  # min_x, max_x = output_image.keys.map(&:first).minmax
  # min_y, max_y = output_image.keys.map(&:last).minmax
  # min_y.upto(max_y) do |y|
  #   puts
  #   min_x.upto(max_x) do |x|
  #     print output_image[[x,y]]
  #   end
  # end
  # puts

  image = output_image.dup
end

puts image.values.filter { |pixel| pixel == '#' }.size

# part 2


image = Hash.new('.')
data.each_with_index do |line, y|
  line.each_char.with_index do |pixel, x|
    image[[x,y]] = pixel if pixel == '#'
  end
end


50.times do |i|
  output_image = Hash.new(i%2 == 1 ? '.' : '#')
  min_x, max_x = image.keys.map(&:first).minmax
  min_y, max_y = image.keys.map(&:last).minmax

  (min_x - 2).upto(max_x + 2) do |x|
    (min_y - 2).upto(max_y + 2) do |y|
      reading = ''
      -1.upto(1) do |dy|
        -1.upto(1) do |dx|
          reading << (image[[x+dx, y+dy]] == '#' ? '1' : '0')
        end
      end
      output_pixel = algo[reading.to_i(2)]
      output_image[[x,y]] = output_pixel
    end
  end

  # min_x, max_x = output_image.keys.map(&:first).minmax
  # min_y, max_y = output_image.keys.map(&:last).minmax
  # min_y.upto(max_y) do |y|
  #   puts
  #   min_x.upto(max_x) do |x|
  #     print output_image[[x,y]]
  #   end
  # end
  # puts

  image = output_image.dup
end

puts image.values.filter { |pixel| pixel == '#' }.size
