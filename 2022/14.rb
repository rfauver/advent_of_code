rocks = File.readlines('14.txt', chomp: true)

# part 1

grid = {}

rocks.each do |rock_path|
  rock_path.split(' -> ').each_cons(2) do |(first, second)|
    first_x, first_y = first.split(',').map(&:to_i)
    second_x, second_y = second.split(',').map(&:to_i)
    if first_x == second_x
      ([first_y, second_y].min).upto([first_y, second_y].max) { |y| grid[[first_x, y]] = :rock }
    else
      ([first_x, second_x].min).upto([first_x, second_x].max) { |x| grid[[x, first_y]] = :rock }
    end
  end
end

def print_grid(grid)
  min_x, max_x = grid.keys.map(&:first).minmax
  min_y, max_y = grid.keys.map(&:last).minmax

  min_y.upto(max_y) do |y|
    min_x.upto(max_x) do |x|
      print grid[[x,y]] ? (grid[[x,y]] == :rock ? '#' : 'O') : '.'
    end
    puts
  end
end

max_y = grid.keys.map(&:last).max
drop_count = 0
done = false

until done
  curr = [500,0]


  until grid[curr]
    if curr.last > max_y
      done = true
      break
    end
    if !grid[[curr.first, curr.last+1]]
      curr = [curr.first, curr.last+1]
    elsif !grid[[curr.first-1, curr.last+1]]
      curr = [curr.first-1, curr.last+1]
    elsif !grid[[curr.first+1, curr.last+1]]
      curr = [curr.first+1, curr.last+1]
    else
      grid[curr] = :sand
    end
  end
  drop_count += 1 unless done
  # print_grid(grid)
  # puts
end

# print_grid(grid)

p drop_count

# part 2

grid = {}

rocks.each do |rock_path|
  rock_path.split(' -> ').each_cons(2) do |(first, second)|
    first_x, first_y = first.split(',').map(&:to_i)
    second_x, second_y = second.split(',').map(&:to_i)
    if first_x == second_x
      ([first_y, second_y].min).upto([first_y, second_y].max) { |y| grid[[first_x, y]] = :rock }
    else
      ([first_x, second_x].min).upto([first_x, second_x].max) { |x| grid[[x, first_y]] = :rock }
    end
  end
end

min_x, max_x = grid.keys.map(&:first).minmax
max_y = grid.keys.map(&:last).max

(min_x-1000).upto(max_x+1000) do |x|
  grid[[x, max_y + 2]] = :rock
end

drop_count = 0
done = false

until done
  curr = [500,0]

  until grid[curr]
    if !grid[[curr.first, curr.last+1]]
      curr = [curr.first, curr.last+1]
    elsif !grid[[curr.first-1, curr.last+1]]
      curr = [curr.first-1, curr.last+1]
    elsif !grid[[curr.first+1, curr.last+1]]
      curr = [curr.first+1, curr.last+1]
    else
      grid[curr] = :sand
      if curr == [500,0]
        done = true
        break
      end
    end
  end
  drop_count += 1
end

p drop_count
