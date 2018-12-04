data = []
File.open("input1", "r") do |f|
	f.each_line do |line|
		data.push(line.strip.to_i)
	end
end



frequency = 0
frequencies = { 0 => 1 }
still_going = true
while still_going
	data.each do |change|
		frequency += change
		if frequencies[frequency]
			still_going = false
			puts frequency
			break
		else
			frequencies[frequency] = 1
		end
	end
end