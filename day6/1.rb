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
coordinates_with_infinate_areas = Hash.new
0.upto(max_x + 1) do |x|
	0.upto(max_y + 1) do |y|
		# for each point, calculate the distance of all the coordinates
		coordinate_distances = {}
		coordinates.each do |coordinate|
			coordinate_distances[coordinate] = (coordinate[0] - x).abs + (coordinate[1] - y).abs
		end

		# shortest distances to the front
		sorted_coordinate_distances = coordinate_distances.sort { |a,b| a[1] <=> b[1] }
		# no ties allowed
		if sorted_coordinate_distances[0][1] != sorted_coordinate_distances[1][1]
			closest_coordinates[x][y] = sorted_coordinate_distances[0][0]
			if x == 0 or y == 0 or x == max_x + 1 or y == max_y + 1
				coordinates_with_infinate_areas[sorted_coordinate_distances[0][0]] = true
			end
		end
	end
end

#puts coordinates_with_infinate_areas

occurences = Hash.new(0)
0.upto(max_x) do |x|
	0.upto(max_y) do |y|
		if !closest_coordinates[x][y].nil? and !coordinates_with_infinate_areas[[closest_coordinates[x][y][0],closest_coordinates[x][y][1]]]
			occurences[closest_coordinates[x][y]] += 1
		end
	end
end

puts occurences.values.max