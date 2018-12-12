class MarbleGame
	attr_reader :marbles, :scores

	def initialize(num_players)
		@marbles = [0]
		@current_index = 0

		@scores = Hash.new
		1.upto(num_players) do |i|
			@scores[i] = 0
		end
	end

	def add_marble(number, player)
		if number % 23 == 0
			@scores[player] += number

			if @current_index - 7 >= 0
				@current_index -= 7
			else
				@current_index = @marbles.length - 7 + @current_index
			end
			@scores[player] += @marbles.delete_at(@current_index)
		else
			if marbles.length == 1 or @current_index == @marbles.length - 2
				@marbles.push(number)
				@current_index = @marbles.length - 1
			elsif @current_index == @marbles.length - 1
				@current_index = 1
				@marbles.insert(@current_index, number)	
			else
				@current_index = @current_index + 2
				@marbles.insert(@current_index, number)
			end
		end
	end
end

num_players = 430
marble_game = MarbleGame.new(num_players)

player = 1
1.upto(71588) do |i|
	marble_game.add_marble(i, player)
	if player == num_players
		player = 1
	else
		player += 1
	end 
end

puts marble_game.scores.max_by{|k,v| v}[1]