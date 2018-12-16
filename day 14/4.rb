class Recipe
  attr_accessor :following, :previous, :value

  def initialize(value, previous_recipe, following_recipe)
    @value = value
    @previous = previous_recipe
    @following = following_recipe
  end
end


class UltimateHotChocolateRecipe
  attr_accessor :recipe_board, :max_index, :first_recipe, :total_recipes

  def initialize
    recipe_1 = Recipe.new(3, nil, nil)
    recipe_2 = Recipe.new(7, recipe_1, recipe_1)
    recipe_1.following = recipe_2

    @total_recipes = 2
    @elf_1_recipe = recipe_1
    @elf_2_recipe = recipe_2
    @first_recipe = recipe_1
    @last_recipe = recipe_2
  end

  def add_and_check_recipes(pattern)
    new_recipes = (@elf_1_recipe.value + @elf_2_recipe.value).to_s.chars.map(&:to_i)
    
    recipe_1 = Recipe.new(new_recipes[0], @last_recipe, @first_recipe)
    @last_recipe.following = recipe_1
    @last_recipe = recipe_1
    @total_recipes += 1
    if check_pattern(pattern)
      return check_pattern(pattern)
    end
    if new_recipes[1]
      recipe_2 = Recipe.new(new_recipes[1], @last_recipe, @first_recipe)
      @last_recipe.following = recipe_2
      @last_recipe = recipe_2
      @total_recipes += 1
      if check_pattern(pattern)
        return check_pattern(pattern)
      end
    end

    1.upto(@elf_1_recipe.value + 1) do |i|
      @elf_1_recipe = @elf_1_recipe.following
    end
    1.upto(@elf_2_recipe.value + 1) do |i|
      @elf_2_recipe = @elf_2_recipe.following
    end

    return nil
  end

  def draw_recipe_board
    print " #{@first_recipe.value} "
    current_recipe = @first_recipe.following
    while current_recipe != @first_recipe
      print " #{current_recipe.value} "
      current_recipe = current_recipe.following
    end
  end

  def check_pattern(pattern)
    current_recipe = @last_recipe
    most_recent_recipe_values = ''
    1.upto(pattern.length) do |i|
      most_recent_recipe_values.prepend(current_recipe.value.to_s)
      if current_recipe.previous.nil?
        return nil
      else
        current_recipe = current_recipe.previous
      end
    end
    if most_recent_recipe_values == pattern
      return @total_recipes - pattern.length
    else
      return nil
    end
  end
end

uhcr = UltimateHotChocolateRecipe.new

1.upto(100000000) do |i|
  if i % 100000 == 0
    puts i
  end
  result = uhcr.add_and_check_recipes('236021')
  if result
    puts result
    break
  end
end


#uhcr.draw_recipe_board

# guessed 352225444
# guessed 100000000  # too high
# guessed 10000000   # too low
# guessed 50000000   (too high but with other one)