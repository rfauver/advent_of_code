steps = File.readlines('9.txt', chomp: true)

# part 1

head = [0,0]
tail = [0,0]

seen = { tail => true }

steps.each do |step|
  dir, num = step.split(' ')
  num.to_i.times do
    case dir
    when 'U'
      head = [head[0], head[1] + 1]
    when 'R'
      head = [head[0] + 1, head[1]]
    when 'D'
      head = [head[0], head[1] - 1]
    when 'L'
      head = [head[0] - 1, head[1]]
    end
    if head[0] == tail[0]
      if head[1] > (tail[1] + 1)
        tail = [tail[0], tail[1] + 1]
      elsif head[1] < (tail[1] - 1)
        tail = [tail[0], tail[1] - 1]
      end
    elsif head[1] == tail[1]
      if head[0] > (tail[0] + 1)
        tail = [tail[0] + 1, tail[1]]
      elsif head[0] < (tail[0] - 1)
        tail = [tail[0] - 1, tail[1]]
      end
    else
      if (head[0] > tail[0] && head[1] > tail[1] + 1) || (head[1] > tail[1] && head[0] > tail[0] + 1)
        tail = [tail[0] + 1, tail[1] + 1]
      elsif (head[0] > tail[0] && head[1] < tail[1] - 1) || (head[1] < tail[1] && head[0] > tail[0] + 1)
        tail = [tail[0] + 1, tail[1] - 1]
      elsif (head[0] < tail[0] && head[1] < tail[1] - 1) || (head[1] < tail[1] && head[0] < tail[0] - 1)
        tail = [tail[0] - 1, tail[1] - 1]
      elsif (head[0] < tail[0] && head[1] > tail[1] + 1) || (head[1] > tail[1] && head[0] < tail[0] - 1)
        tail = [tail[0] - 1, tail[1] + 1]
      end
    end
    seen[tail] = true
  end
end

p seen.length

# part 2

knots = Array.new(10) { [0,0] }
seen = {}

steps.each do |step|
  dir, num = step.split(' ')
  num.to_i.times do
    head = knots[0]
    case dir
    when 'U'
      knots[0] = [head[0], head[1] + 1]
    when 'R'
      knots[0] = [head[0] + 1, head[1]]
    when 'D'
      knots[0] = [head[0], head[1] - 1]
    when 'L'
      knots[0] = [head[0] - 1, head[1]]
    end
    knots.each_cons(2).with_index do |_, i|
      head = knots[i]
      tail = knots[i+1]
      if head[0] == tail[0]
        if head[1] > (tail[1] + 1)
          knots[i+1] = [tail[0], tail[1] + 1]
        elsif head[1] < (tail[1] - 1)
          knots[i+1] = [tail[0], tail[1] - 1]
        end
      elsif head[1] == tail[1]
        if head[0] > (tail[0] + 1)
          knots[i+1] = [tail[0] + 1, tail[1]]
        elsif head[0] < (tail[0] - 1)
          knots[i+1] = [tail[0] - 1, tail[1]]
        end
      else
        if (head[0] > tail[0] && head[1] > tail[1] + 1) || (head[1] > tail[1] && head[0] > tail[0] + 1)
          knots[i+1] = [tail[0] + 1, tail[1] + 1]
        elsif (head[0] > tail[0] && head[1] < tail[1] - 1) || (head[1] < tail[1] && head[0] > tail[0] + 1)
          knots[i+1] = [tail[0] + 1, tail[1] - 1]
        elsif (head[0] < tail[0] && head[1] < tail[1] - 1) || (head[1] < tail[1] && head[0] < tail[0] - 1)
          knots[i+1] = [tail[0] - 1, tail[1] - 1]
        elsif (head[0] < tail[0] && head[1] > tail[1] + 1) || (head[1] > tail[1] && head[0] < tail[0] - 1)
          knots[i+1] = [tail[0] - 1, tail[1] + 1]
        end
      end
    end
    seen[knots.last] = true
  end
end

# min_x, max_x = seen.keys.map(&:first).minmax
# min_y, max_y = seen.keys.map(&:last).minmax
# max_y.downto(min_y) do |y|
#   min_x.upto(max_x) do |x|
#     print (seen[[x,y]] ? 'X' : '.')
#   end
#   puts
# end

p seen.length
