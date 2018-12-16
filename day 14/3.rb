class UltimateHotChocolateRecipe
	attr_accessor :recipe_board, :max_index

	def initialize
		@recipe_board = { 0 => 3, 1 => 7 }
		@max_index = 1
		@elf_1_index = 0
		@elf_2_index = 1
	end

	def find_new_index(current_index)
		new_index = current_index + @recipe_board[current_index] + 1
		while new_index > @recipe_board.size - 1
			new_index = new_index - @recipe_board.size
		end
		return new_index
	end

	def add_recipes
		new_recipes = (@recipe_board[@elf_1_index] + @recipe_board[@elf_2_index]).to_s.chars.map(&:to_i)


		@recipe_board[@max_index+1] = new_recipes[0]
		@max_index += 1
		if new_recipes[1]
			@recipe_board[@max_index+1] = new_recipes[1]
			@max_index += 1
		end
		@elf_1_index = find_new_index(@elf_1_index)
		@elf_2_index = find_new_index(@elf_2_index)
	end

	def check_pattern(pattern)
		most_recent_recipes = ''
		pattern_length = pattern.length
		(@recipe_board.size - 1 - pattern_length + 1 ).upto(@recipe_board.length - 1) do |i|
			most_recent_recipes += @recipe_board[i].to_s
		end
		if most_recent_recipes == pattern.to_s
			return true
		else
			return false
		end
	end
end

uhcr = UltimateHotChocolateRecipe.new

#puts uhcr.recipe_board


1.upto(200000000) do |i|
	if i % 10000 == 0
		puts i
	end
	uhcr.add_recipes
	if uhcr.check_pattern('236021')
		puts uhcr.max_index - 5
		break
	end
end

#puts uhcr.recipe_board