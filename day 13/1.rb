def draw_map(map,trains)
	y = 0
	while map[y]
		x = 0
		while map[y][x]
			train = trains.find {|t| x == t[:x] and y == t[:y]}
			if train
				if train[:direction] == 'right'
					print '>'
				elsif train[:direction] == 'left'
					print '<'
				elsif train[:direction] == 'up'
					print '^'
				elsif train[:direction] == 'down'
					print 'v'
				end
			else
				print map[y][x]
			end
			x += 1
		end
		puts ""
		y += 1
	end
	puts ""
end

def move_trains(map,trains)
	trains.sort_by {|t| [ t[:y], t[:x] ] }.each do |t|
		new_x = t[:x]
		new_y = t[:y]
		if t[:direction] == 'right'
			new_x += 1
		elsif t[:direction] == 'left'
			new_x -= 1
		elsif t[:direction] == 'up'
			new_y -= 1
		elsif t[:direction] == 'down'
			new_y += 1
		end
		if trains.find {|t2| new_x == t2[:x] and new_y == t2[:y]}
			puts "CRASH @ #{new_x},#{new_y}"
			return false
		else
			t[:x] = new_x
			t[:y] = new_y
			if map[new_y][new_x] == '\\'
				if t[:direction] == 'up'
					t[:direction] = 'left'
				elsif t[:direction] == 'down'
					t[:direction] = 'right'
				elsif t[:direction] == 'left'
					t[:direction] = 'up'
				else
					t[:direction] = 'down'
				end
			elsif map[new_y][new_x] == '/'
				if t[:direction] == 'up'
					t[:direction] = 'right'
				elsif t[:direction] == 'down'
					t[:direction] = 'left'
				elsif t[:direction] == 'left'
					t[:direction] = 'down'
				else
					t[:direction] = 'up'
				end
			elsif map[new_y][new_x] == '+'
				if t[:direction] == 'down'
					if t[:next_intersection_turn] == 'left'
						t[:direction] = 'right'
					elsif t[:next_intersection_turn] == 'right'
						t[:direction] = 'left'
					end
				elsif t[:direction] == 'up'
					if t[:next_intersection_turn] == 'left'
						t[:direction] = 'left'
					elsif t[:next_intersection_turn] == 'right'
						t[:direction] = 'right'
					end
				elsif t[:direction] == 'left'
					if t[:next_intersection_turn] == 'left'
						t[:direction] = 'down'
					elsif t[:next_intersection_turn] == 'right'
						t[:direction] = 'up'
					end
				elsif t[:direction] == 'right'
					if t[:next_intersection_turn] == 'left'
						t[:direction] = 'up'
					elsif t[:next_intersection_turn] == 'right'
						t[:direction] = 'down'
					end
				end
				if t[:next_intersection_turn] == 'left'
					t[:next_intersection_turn] = 'straight'
				elsif t[:next_intersection_turn] == 'straight'
					t[:next_intersection_turn] = 'right'
				else
					t[:next_intersection_turn] = 'left'
				end
			end
		end
	end
	return true
end

map = Hash.new
trains = Array.new
File.open("input13", "r") do |f|
	y = 0
	f.each_line do |line|
		map[y] = Hash.new
		line.chomp.chars.each_with_index do |segment,x|
			if segment == '>'
				trains.push({ x: x, y: y, direction: 'right', next_intersection_turn: 'left' })
				map[y][x] = '-'
			elsif segment == '<'
				trains.push({ x: x, y: y, direction: 'left', next_intersection_turn: 'left' })
				map[y][x] = '-'
			elsif segment == '^'
				trains.push({ x: x, y: y, direction: 'up', next_intersection_turn: 'left' })
				map[y][x] = '|'
			elsif segment == 'v'
				trains.push({ x: x, y: y, direction: 'down', next_intersection_turn: 'left' })
				map[y][x] = '|'
			else
				map[y][x] = segment
			end
		end
		y += 1
	end
end


draw_map(map,trains)
while move_trains(map,trains)
	#draw_map(map,trains)
end