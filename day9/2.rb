class Marble
	attr_accessor :previous, :next
	attr_reader   :value
	def initialize(value)
		@value = value
		@next  = nil
		@previous = nil
	end
end


class MarbleGame
	attr_reader :scores

	def initialize(num_players)
		@scores = Hash.new
		1.upto(num_players) do |i|
			@scores[i] = 0
		end

		@current_marble = Marble.new(0)
	end
	
	def add_marble(value, player)
		if value % 23 == 0
			@scores[player] += value

			marble_to_remove = @current_marble.previous.previous.previous.previous.previous.previous.previous
			@scores[player] += marble_to_remove.value
			marble_to_remove.next.previous = marble_to_remove.previous
			marble_to_remove.previous.next = marble_to_remove.next
			@current_marble = marble_to_remove.next
		else
			new_marble = Marble.new(value)
			# this is the first marble being added after the 0 marble
			if !@current_marble.next
				new_marble.previous = @current_marble
				new_marble.next = @current_marble
				@current_marble.previous = new_marble
				@current_marble.next = new_marble
			else
				new_marble = Marble.new(value)

				new_marble.next = @current_marble.next.next
				new_marble.previous = @current_marble.next

				@current_marble.next.next.previous = new_marble
				@current_marble.next.next = new_marble
			end
			@current_marble = new_marble
		end
	end
	
	def find(value)
		node = @current_marble
		return false if !node.next
		return node  if node.value == value
		while (node = node.next)
			return node if node.value == value
		end
	end
	
	def marbles
		values = [0]
		node = find(0)
		while node.next.value != 0
			values << node.next.value
			node = node.next
		end
		puts values.to_s
	end
end

num_players = 430
marble_game = MarbleGame.new(num_players)

player = 1
1.upto(7158800) do |i|
	if i % 10000 == 0
		puts i
	end
	marble_game.add_marble(i, player)
	if player == num_players
		player = 1
	else
		player += 1
	end 
end

#marble_game.marbles
puts marble_game.scores.max_by{|k,v| v}[1]