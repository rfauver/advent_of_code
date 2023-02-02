# part 1

foods = eval(File.read('/Users/rfauver/Desktop/data21.txt'));

allergens = foods.flat_map { |food| food[:allergens] }.uniq

cant = foods.flat_map { |food| food[:ingredients] }.uniq - allergens.flat_map do |allergen|
  foods.select { |food| food[:allergens].include?(allergen) }.map do |food|
    food[:ingredients]
  end.reduce(&:&)
end.uniq

foods.sum do |food|
  cant.map { |ingredient| food[:ingredients].count(ingredient) }.sum
end


# part 2

allergens.map do |allergen|
  [allergen, foods.select { |food| food[:allergens].include?(allergen) }.map do |food|
    food[:ingredients]
  end.reduce(&:&)]
end.to_h


allergen_map = {"fish"=> "nhvprqb", "nuts"=>"jhtfzk", "dairy"=>"vcckp", "wheat"=> "zmh", "sesame"=>"qbgbmc", "peanuts"=>"mgkhhc", "eggs"=>"hjz", "shellfish"=>"bzcrknb"}
allergen_map.sort_by { |k, v| k }.map { |(k, v)| v }.join(',')
