data = File.readlines('12.txt', chomp: true)

graph = {}
data.each do |line|
  first, second = line.split('-')
  graph[first] = (graph[first] || []) + [second]
  graph[second] = (graph[second] || []) + [first]
end

# part 1

@paths = []

def search(current, path, visited, graph)
  options = graph[current]
  options.each do |node|
    if node == 'end'
      @paths << path
      next
    end
    unless visited[node]
      next_visited = visited.dup
      if node.downcase == node
        next_visited[node] = true
      end
      next_path = path.dup + [node]
      search(node, next_path, next_visited, graph)
    end
  end
end

search('start', [], { 'start' => true }, graph)

p @paths.length

# part 2

@paths = []

def search_2(current, path, visited, graph, visited_twice)
  options = graph[current]
  options.each do |node|
    if node == 'end'
      @paths << path
      next
    end
    unless visited[node] == 2 || (visited_twice && visited[node])
      next_visited = visited.dup
      if node.downcase == node
        next_visited[node] = (next_visited[node] || 0) + 1
      end
      next_path = path.dup + [node]
      search_2(node, next_path, next_visited, graph, visited_twice || next_visited[node] == 2)
    end
  end
end

search_2('start', [], { 'start' => 2 }, graph, false)

p @paths.length
