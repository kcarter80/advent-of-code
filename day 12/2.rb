class Pot
	attr_accessor :previous, :following, :next_generation, :plant
	attr_reader   :position
	def initialize(value,position,previous=nil,following=nil)
		@plant = value
		@position = position
		@following  = following
		@previous = previous
		@next_generation = nil
	end
end

class Pots
	attr_accessor :left_most_plant_pot, :left_most_pot, :right_most_plant_pot, :right_most_pot

	# position will always be 0
	def initialize(pot)
		@left_most_pot = pot
		@right_most_pot = pot
	end

	def set_left_most_plant_pot(pot)	
		@left_most_plant_pot = pot
		# need 2 empty pots to the left
		while @left_most_plant_pot.position - @left_most_pot.position < 2
			new_pot = Pot.new( (false), @left_most_pot.position - 1)
			new_pot.following = @left_most_pot
			@left_most_pot.previous = new_pot
			@left_most_pot = new_pot
		end
	end

	def set_right_most_plant_pot(pot)
		@right_most_plant_pot = pot
		# need 2 empty pots to the right
		while @right_most_pot.position - @right_most_plant_pot.position  < 2
			new_pot = Pot.new( (false), @right_most_pot.position + 1)
			new_pot.previous = @right_most_pot
			@right_most_pot.following = new_pot
			@right_most_pot = new_pot
		end	
	end

	def display_from(position)
		result = ''
		if position < @left_most_plant_pot.position
			while position < @left_most_plant_pot.position
				result += '.'
				position += 1
			end
		end
		this_pot = @left_most_plant_pot
		while !this_pot.following.nil?
			result += this_pot.plant ? '#' : '.'
			this_pot = this_pot.following
		end
		result += this_pot.plant ? '#' : '.'
		puts result
	end

	def advance_generation(plant_patterns)
		current_pot = left_most_pot
		while !current_pot.nil?
			pattern = current_pot.plant ? '1' : '0'
			if current_pot.previous
				pattern.prepend(current_pot.previous.plant ? '1' : '0')
				if current_pot.previous.previous
					pattern.prepend(current_pot.previous.previous.plant ? '1' : '0')
				else
					pattern.prepend('0')
				end
			else
				pattern.prepend('00')
			end

			if current_pot.following
				pattern.concat(current_pot.following.plant ? '1' : '0')
				if current_pot.following.following
					pattern.concat(current_pot.following.following.plant ? '1' : '0')
				else
					pattern.concat('0')
				end
			else
				pattern.concat('00')
			end
			if (plant_patterns.find_index(pattern.to_i(2)))
				current_pot.next_generation = true
			end
			current_pot = current_pot.following
		end
		current_pot = left_most_pot
		while !current_pot.nil?
			current_pot.plant = current_pot.next_generation
			current_pot.next_generation = nil
			if current_pot.plant
				if current_pot.position < @left_most_plant_pot.position
					set_left_most_plant_pot(current_pot)
				end
				last_plant_pot = current_pot
			end
			current_pot = current_pot.following
		end
		if last_plant_pot.position > @right_most_plant_pot.position
			set_right_most_plant_pot(last_plant_pot)
		end
	end

	def sum
		sum = 0
		current_pot = @left_most_plant_pot
		while current_pot.position <= @right_most_plant_pot.position
			if current_pot.plant
				sum += current_pot.position
			end
			current_pot = current_pot.following
		end
		return sum
	end

end


plant_patterns = []
pots = nil
File.open("input12", "r") do |f|
	i = 0
	last_pot = nil
	f.each_line do |line|
		stripped_line = line.strip
		if i == 0
			initial_state = /(?<=initial state: )(.*)/.match(stripped_line).to_s
			last_pot = nil
			right_most_plant_pot = nil
			initial_state.chars.each_with_index do |c,i|	
				if i == 0
					# this is the first pot
					last_pot = Pot.new( (c == '#' ? true : false), i )
					pots = Pots.new(last_pot)
				else
					# set the previous pot
					pot = Pot.new( (c == '#' ? true : false), i, last_pot )
					last_pot.following = pot
					last_pot = pot
					pots.right_most_pot = last_pot
				end
				if last_pot.plant
					if pots.left_most_plant_pot.nil?
						pots.set_left_most_plant_pot(last_pot)
					end
					right_most_plant_pot = last_pot
				end
			end
			pots.set_right_most_plant_pot(right_most_plant_pot)
		elsif i >= 2
			result = /(?<=\=\> )(.*)/.match(stripped_line).to_s
			if result == '#'
				pattern = /(.*)(?=\=\> )/.match(stripped_line).to_s
				pattern_array = []
				pattern.chars.each do |c|
					if c == '#'
						pattern_array.push(1) 
					elsif c == '.'
						pattern_array.push(0)
					end
				end
				#puts "#{pattern_array.join} #{pattern_array.join.to_i(2)}"
				plant_patterns.push(pattern_array.join.to_i(2))
			end
		end
		i += 1
	end
end

last_sum = 0 
1.upto(1000) do |i|
	if ( i % 100 == 0)
		#puts i
	end
	this_sum = pots.sum
	puts this_sum - last_sum
	#pots.display_from(0)
	last_sum = this_sum
	pots.advance_generation(plant_patterns)
end
# the difference is 42 per iteration

puts pots.sum + 42 * (50000000000 - 1000)