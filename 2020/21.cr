class Program
  @input : Array(String)

  def initialize
    @input = File.read("21.txt").chomp.split("\n")
  end

  def execute
    ingredient_food_map = Hash(String, Set(Int32)).new { Set(Int32).new }
    allergen_food_map = Hash(String, Set(Int32)).new { Set(Int32).new }

    # Food contains allergen but does not contains ingredient => ingredient does not contain allergen
    @input.each_with_index do |food, food_id|
      ingredients_list, allergens_list = food.chomp(")").split(" (contains ")
      ingredients = ingredients_list.split(' ')
      allergens = allergens_list.split(", ")

      ingredients.each do |ingredient|
        ingredient_food_map[ingredient] = ingredient_food_map[ingredient].add(food_id)
      end

      allergens.each do |allergen|
        allergen_food_map[allergen] = allergen_food_map[allergen].add(food_id)
      end
    end

    # Part 1
    safe_ingredients_count = ingredient_food_map.keys.reject do |ingredient|
      allergen_food_map.any? do |_, food_ids|
        food_ids.all? { |food_id| ingredient_food_map[ingredient].includes?(food_id) }
      end
    end.sum { |ingredient| ingredient_food_map[ingredient].size }
    puts safe_ingredients_count

    allergic_ingredients = ingredient_food_map.keys.select do |ingredient|
      allergen_food_map.any? do |_, food_ids|
        food_ids.all? { |food_id| ingredient_food_map[ingredient].includes?(food_id) }
      end
    end

    # Part 2
    sorted_allergens = allergen_food_map.keys.sort
    allergic_ingredients.permutations.each do |permutation|
      correct = true
      permutation.each_with_index do |ingredient, idx|
        allergen = sorted_allergens[idx]
        food_ids = allergen_food_map[allergen]
        correct = false unless food_ids.all? { |food_id| ingredient_food_map[ingredient].includes?(food_id) }
      end

      if correct
        puts permutation.join(',')
        break
      end
    end
  end
end

Program.new.execute
