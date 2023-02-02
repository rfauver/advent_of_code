data = File.readlines('7.txt', chomp: true)

# part 1

file_system = {}
parent_stack = []
dir = file_system
read_mode = false

data.each do |line|
  if line.start_with?('$ cd')
    read_mode = false
    folder = line.match(/\$ cd (.+)/)[1]
    if folder == '/'
      dir = file_system
    elsif folder == '..'
      dir = parent_stack.pop
    else
      parent_stack.push(dir)
      dir = dir[folder]
    end
  elsif read_mode
    if line.start_with?('dir')
      folder = line.match(/dir (.+)/)[1]
      dir[folder] = {}
    else
      size, file = line.split(' ')
      dir[file] = size.to_i
    end
  elsif line == '$ ls'
    read_mode = true
  end
end

@under = []
@all = []
def get_size(dir)
  total = 0
  dir.values.each do |value|
    if value.is_a?(Integer)
      total += value
    else
      total += get_size(value)
    end
  end
  if total <= 100000
    @under << total
  end
  @all << total
  total
end

get_size(file_system)

p @under.sum

# part 2

total = get_size(file_system)

curr_unused_space = 70000000 - total
needed = 30000000 - curr_unused_space
@all.sort.each do |size|
  if size > needed
    p size
    break
  end
end
