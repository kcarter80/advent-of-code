data = []
twos = 0
threes = 0
at_least_one_two = false
at_least_one_three = false
File.open("input2", "r") do |f|
	f.each_line do |line|
		character_arrays = line.strip.chars.group_by{|x| x}
		character_arrays.each do |k,v|
			if v.count == 2
				at_least_one_two = true
			end
			if v.count == 3
				at_least_one_three = true
			end
		end
		if at_least_one_two
			twos += 1
		end
		if at_least_one_three
			threes += 1
		end
		at_least_one_two = false
		at_least_one_three = false
	end
end

puts twos * threes