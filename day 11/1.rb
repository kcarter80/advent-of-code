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
1.upto(298) do |x|
	1.upto(298) do |y|
		if !total_powers[x]
			total_powers[x] = Hash.new
		end
		total_powers[x][y] = power_levels[x][y] + power_levels[x + 1][y] + power_levels[x + 2][y] + power_levels[x][y + 1] + power_levels[x + 1][y + 1] + power_levels[x + 2][y + 1] + power_levels[x][y + 2] + power_levels[x + 1][y + 2] + power_levels[x + 2][y + 2]
		if max_power.nil? || total_powers[x][y] > max_power
			max_power = total_powers[x][y]
			max_x = x
			max_y = y
		end
	end
end

puts "#{max_power} @ #{max_x},#{max_y}"