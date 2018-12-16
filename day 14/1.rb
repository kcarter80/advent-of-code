class UltimateHotChocolateRecipe
	attr_accessor :recipe_board

	def initialize
		@recipe_board = [3,7]
		@elf_1_index = 0
		@elf_2_index = 1
	end

	def find_new_index(current_index)
		
		new_index = current_index + @recipe_board[current_index] + 1
		while new_index > @recipe_board.length - 1
			new_index = new_index - @recipe_board.length
		end
		return new_index
	end

	def add_recipes
		@recipe_board += (@recipe_board[@elf_1_index] + @recipe_board[@elf_2_index]).to_s.chars.map(&:to_i)
		@elf_1_index = find_new_index(@elf_1_index)
		@elf_2_index = find_new_index(@elf_2_index)
		#puts "#{@elf_1_index} #{@elf_2_index}"
	end

	def draw_recipe_board
		@recipe_board.each_with_index do |recipe,i|
			if @elf_1_index == i
				print "(#{@recipe_board[i]})"
			elsif @elf_2_index == i
				print "[#{@recipe_board[i]}]"
			else
				print " #{@recipe_board[i]} "
			end
		end
		print "\n"
	end

	def score_next_ten_after_index(i)
		score = ""
		i.upto(i+9) do |k|
			score += @recipe_board[k].to_s
		end
		return score
	end
end

uhcr = UltimateHotChocolateRecipe.new
uhcr.draw_recipe_board

1.upto(409551+20) do |i|
	if i % 10000 == 0
		puts i
	end
	uhcr.add_recipes
	#uhcr.draw_recipe_board
end

puts uhcr.score_next_ten_after_index(5)
puts uhcr.score_next_ten_after_index(18)
puts uhcr.score_next_ten_after_index(2018)
puts uhcr.score_next_ten_after_index(409551)