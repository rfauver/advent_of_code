data = eval(File.read('/Users/rfauver/Desktop/data4.txt'));
fields = %i[byr iyr eyr hgt hcl ecl pid cid]

# part 1

data.reduce([{}]) do |pps, line|
  pps.last.merge!(line)
  line == {} ? pps << {} : pps
end.count { |pp| [[], [:cid]].include?(fields - pp.keys) }

# part 2

data.reduce([{}]) do |pps, line|
  pps.last.merge!(line)
  line == {} ? pps << {} : pps
end.count do |pp|
  [[], [:cid]].include?(fields - pp.keys) &&
  (1920..2002).include?(pp[:byr].to_i) &&
  (2010..2020).include?(pp[:iyr].to_i) &&
  (2020..2030).include?(pp[:eyr].to_i) &&
  (pp[:hgt].end_with?('cm') ?
    (150..193).include?(pp[:hgt].to_i) :
    pp[:hgt].end_with?('in') && (59..76).include?(pp[:hgt].to_i)) &&
  pp[:hcl].match?(/^#[a-z0-9]{6}$/) &&
  %w[amb blu brn gry grn hzl oth].include?(pp[:ecl]) &&
  pp[:pid].match?(/^[0-9]{9}$/)
end
