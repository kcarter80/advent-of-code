points = []

def draw_points(points)
	min_x = 0
	max_x = 0
	min_y = 0
	max_y = 0
	points.each do |point|
		if point[:x] > max_x
			max_x = point[:x]
		end
		if point[:x] < min_x
			min_x = point[:x]
		end
		if point[:y] > max_y
			max_y = point[:y]
		end
		if point[:y] < min_y
			min_y = point[:y]
		end
	end

	#grid = Array.new(max_y - min_y + 1){Array.new(max_x - min_x + 1)}
	grid = Hash.new

	points.each do |point|
		x = point[:x] - min_x
		y = point[:y] - min_y
		if !grid[y]
			grid[y] = Hash.new
		end
		grid[y][x] = true
	end

	width = max_x - min_x
	height = max_y - min_y

	0.upto(height) do |y|
		0.upto(width) do |x|
			if grid[y] and grid[y][x]
				print '#'
			else
				print '.'
			end
		end
		print "\n"
	end
end

def advance_points(points)
	points.each do |point|
		point[:x] = point[:x] + point[:x_velocity]
		point[:y] = point[:y] + point[:y_velocity]
	end
end

def last_points(points)
	points.each do |point|
		point[:x] = point[:x] - point[:x_velocity]
		point[:y] = point[:y] - point[:y_velocity]
	end
end

def get_area(points)
	min_x = 0
	max_x = 0
	min_y = 0
	max_y = 0
	points.each do |point|
		if point[:x] > max_x
			max_x = point[:x]
		end
		if point[:x] < min_x
			min_x = point[:x]
		end
		if point[:y] > max_y
			max_y = point[:y]
		end
		if point[:y] < min_y
			min_y = point[:y]
		end
	end
	return max_x * max_y
end

File.open("input10", "r") do |f|
	f.each_line do |line|
		stripped_line = line.strip
		# eg: position=< 9,  1> velocity=< 0,  2>
		x = /(?<=n=<)(.*)(?=> v)/.match(stripped_line).to_s.split(',')[0].to_i
		y = /(?<=n=<)(.*)(?=> v)/.match(stripped_line).to_s.split(',')[1].to_i
		x_velocity = /(?<=y=<)(.*)(?=>)/.match(stripped_line).to_s.split(',')[0].to_i
		y_velocity = /(?<=y=<)(.*)(?=>)/.match(stripped_line).to_s.split(',')[1].to_i
		points.push({'x': x, y: y, x_velocity: x_velocity, y_velocity: y_velocity})
	end
end


this_area = get_area(points)
last_area = nil
puts this_area
i = 0
while last_area == nil or last_area > this_area
	last_area = this_area
	advance_points(points)
	i += 1
	this_area = get_area(points)
	puts "#{last_area} #{this_area} #{i}"
end

last_points(points)
draw_points(points)