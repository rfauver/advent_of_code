blueprints = File.readlines('19.txt', chomp: true).map do |line|
  ore_cost = line.match(/ore robot costs (\d+)/)[1].to_i
  clay_cost = line.match(/clay robot costs (\d+)/)[1].to_i
  obsidian_cost = line.match(/obsidian robot costs (\d+) ore and (\d+)/).captures.map(&:to_i)
  geode_cost = line.match(/geode robot costs (\d+) ore and (\d+)/).captures.map(&:to_i)
  {
    ore: { ore: ore_cost },
    clay: { ore: clay_cost },
    obsidian: { ore: obsidian_cost[0], clay: obsidian_cost[1] },
    geode: { ore: geode_cost[0], obsidian: geode_cost[1] }
  }
end

@stored = {}

# For any resource R that's not geode: if you already have X robots creating resource R,
# a current stock of Y for that resource, T minutes left, and no robot requires more
# than Z of resource R to build, and X * T+Y >= T * Z, then you never need to build another
# robot mining R anymore.


def get_geode_count(blueprint, time_left, robots, resources)
  # p [time_left, robots, resources]
  return robots[:geode] if time_left == 1
  key = [time_left, robots, resources].to_s
  return @stored[key] if @stored[key]

  options = []
  can_buid_geode_bot = resources[:obsidian] >= blueprint.dig(:geode, :obsidian) && resources[:ore] >= blueprint.dig(:geode, :ore)
  if can_buid_geode_bot
    options << get_geode_count(
      blueprint,
      time_left-1,
      robots.merge({ geode: robots[:geode]+1}),
      {
        ore: robots[:ore] + resources[:ore] - blueprint.dig(:geode, :ore),
        clay: robots[:clay] + resources[:clay],
        obsidian: robots[:obsidian] + resources[:obsidian] - blueprint.dig(:geode, :obsidian)
      }
    )
  end
  if resources[:clay] >= blueprint.dig(:obsidian, :clay) &&
     resources[:ore] >= blueprint.dig(:obsidian, :ore) &&
     (robots[:obsidian]*time_left) + resources[:obsidian] < time_left*blueprint.dig(:geode, :obsidian)
    options << get_geode_count(
      blueprint,
      time_left-1,
      robots.merge({ obsidian: robots[:obsidian]+1}),
      {
        ore: robots[:ore] + resources[:ore] - blueprint.dig(:obsidian, :ore),
        clay: robots[:clay] + resources[:clay] - blueprint.dig(:obsidian, :clay),
        obsidian: robots[:obsidian] + resources[:obsidian]
      }
    )
  end
  if resources[:ore] >= blueprint.dig(:clay, :ore) &&
     (robots[:clay]*time_left) + resources[:clay] < time_left*blueprint.dig(:obsidian, :clay)
    options << get_geode_count(
      blueprint,
      time_left-1,
      robots.merge({ clay: robots[:clay]+1}),
      {
        ore: robots[:ore] + resources[:ore] - blueprint.dig(:clay, :ore),
        clay: robots[:clay] + resources[:clay],
        obsidian: robots[:obsidian] + resources[:obsidian]
      }
    )
  end
  if resources[:ore] >= blueprint.dig(:ore, :ore) &&
     (robots[:ore]*time_left) + resources[:ore] < time_left*([blueprint.dig(:ore, :ore), blueprint.dig(:clay, :ore)].max)
    options << get_geode_count(
      blueprint,
      time_left-1,
      robots.merge({ ore: robots[:ore]+1}),
      {
        ore: robots[:ore] + resources[:ore] - blueprint.dig(:ore, :ore),
        clay: robots[:clay] + resources[:clay],
        obsidian: robots[:obsidian] + resources[:obsidian]
      }
    )
  end
  if !can_buid_geode_bot
    options << get_geode_count(
      blueprint,
      time_left-1,
      robots,
      {
        ore: robots[:ore] + resources[:ore],
        clay: robots[:clay] + resources[:clay],
        obsidian: robots[:obsidian] + resources[:obsidian]
      }
    )
  end
  best = options.max + robots[:geode]
  # p options if can_buid_geode_bot && best == options.last + robots[:geode]
  @stored[key] = best
  best
end



# geode_counts = blueprints.map.with_index do |blueprint, i|
#   p i
#   @stored = {}
#   [i+1, get_geode_count(blueprint, 24, { ore: 1, clay: 0, obsidian: 0, geode: 0 }, { ore: 0, clay: 0, obsidian: 0 })]
# end
# p geode_counts

# p geode_counts.map {|(i,count)| i * count }.sum

# part 2

geode_counts = blueprints[0..2].map do |blueprint|
  p 'blueprint'
  @stored = {}
  get_geode_count(blueprint, 32, { ore: 1, clay: 0, obsidian: 0, geode: 0 }, { ore: 0, clay: 0, obsidian: 0 })
end
p geode_counts

p geode_counts.reduce(&:*)
