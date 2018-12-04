events = []
File.open("input4", "r") do |f|
	f.each_line do |line|
		stripped_line = line.strip
		date = /(?<=\[)(.*)(?=\])/.match(stripped_line).to_s
		event = /(?<=\] )(.*)/.match(stripped_line).to_s
		events.push({'date' => date, 'event' => event})
	end
end
events.sort! { |x,y| x['date'] <=> y['date'] }

guards = Hash.new()
current_guard = nil

events.each do |e|
	# e.g. Guard #89 begins shift
	if /Guard/.match(e['event'])
		current_guard = /(?<=Guard #)(.*)(?= begins)/.match(e['event']).to_s
		if !guards[current_guard]
			guards[current_guard] = Array.new(60,0)
		end
	else
		minute = /(?<=:)(.*)/.match(e['date']).to_s.to_i
		# increments or decrements from this minute til 59 based on whether they are asleep or awake
		if /falls/.match(e['event'])
			# asleep
			minute.upto(59) do |i|
				guards[current_guard][i] += 1					
			end
		else
			# awake
			minute.upto(59) do |i| 
				guards[current_guard][i] -= 1					
			end
		end
	end
end

guards.each do |k,v|
	puts 'guard: ' + k + ' total minutes slept: ' + v.inject(0){|sum,x| sum + x }.to_s + ' sleepiest minute: ' + v.rindex(v.max).to_s + ' minutes slept: ' + v.max.to_s
end