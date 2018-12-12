serial_number = 3999
power_levels = Hash.new

1.upto(300) do |x|
	1.upto(300) do |y|
		rack_id = x + 10
		power_level = rack_id * y
		power_level += serial_number
		power_level *= rack_id
		power_level = power_level.digits[2] ? power_level.digits[2] : 0
		power_level -= 5

		if !power_levels[x]
			power_levels[x] = Hash.new
		end
		power_levels[x][y] = power_level 
	end
end

total_powers = Hash.new
max_x = nil
max_y = nil
max_power = nil
max_box_size = nil

1.upto(300) do |box_size|
	puts box_size
	last_coord = 301 - box_size
	1.upto(last_coord) do |x|
		1.upto(last_coord) do |y|
			if !total_powers[x]
				total_powers[x] = Hash.new
			end
			# always include the 0,0 square
			total_powers[x][y] = 0
			0.upto(box_size - 1) do |x_coord|
				0.upto(box_size - 1) do |y_coord|
					total_powers[x][y] += power_levels[x+x_coord][y+y_coord]
				end
			end

			if max_power.nil? || total_powers[x][y] > max_power
				max_power = total_powers[x][y]
				max_x = x
				max_y = y
				max_box_size = box_size
				puts "#{max_power} @ #{max_x},#{max_y},#{max_box_size}" 
			end
		end
	end
end