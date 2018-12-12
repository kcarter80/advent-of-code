coordinates = []

File.open("input6", "r") do |f|
	f.each_line do |line|
		stripped_line = line.strip
		x = /(.*)(?=, )/.match(stripped_line).to_s.to_i
		y = /(?<=, )(.*)/.match(stripped_line).to_s.to_i
		coordinates.push([x,y])
	end
end

max_x = coordinates.max {|a,b| a[0] <=> b[0] }[0]
min_x = coordinates.max {|a,b| b[0] <=> a[0] }[0]
max_y = coordinates.max {|a,b| a[1] <=> b[1] }[1]
min_y = coordinates.max {|a,b| b[1] <=> a[1] }[1]

closest_coordinates = Array.new(max_x+2){Array.new(max_y+2)}
coordinates_within_the_limit = 0
0.upto(max_x + 1) do |x|
	0.upto(max_y + 1) do |y|
		# for each point, calculate the distance of all the coordinates
		too_far = 
		coordinate_distances_sum = 0
		coordinates.each do |coordinate|
			coordinate_distances_sum += (coordinate[0] - x).abs + (coordinate[1] - y).abs	
		end
		if coordinate_distances_sum < 10000
			coordinates_within_the_limit += 1
		end
	end
end

puts coordinates_within_the_limit