data = Array.new(2000) { Array.new(2000,0) }
two_claims = 0
File.open("input3", "r") do |f|
	f.each_line do |line|
		stripped_line = line.strip
		# eg: #123 @ 3,2: 5x4
		id = /(?<=#)(.*)(?= @)/.match(stripped_line)
		left_edge = /(?<=@ )(.*)(?=,)/.match(stripped_line).to_s.to_i
		top_edge = /(?<=,)(.*)(?=: )/.match(stripped_line).to_s.to_i
		width = /(?<=: )(.*)(?=x)/.match(stripped_line).to_s.to_i
		height = /(?<=x)(.*)/.match(stripped_line).to_s.to_i
		for x in left_edge..(left_edge + width - 1)
			for y in top_edge..(top_edge + height-1)
				#puts "#{x} #{y} #{data[x][y]}"
				if data[x][y] == 1
					two_claims += 1	
				end
				data[x][y] += 1
 			end
		end
		#puts "#{id} #{left_edge} #{top_edge} #{width} #{height}"
	end
end

File.open("input3", "r") do |f|
	this_is_it = true
	f.each_line do |line|
		stripped_line = line.strip
		# eg: #123 @ 3,2: 5x4
		id = /(?<=#)(.*)(?= @)/.match(stripped_line)
		left_edge = /(?<=@ )(.*)(?=,)/.match(stripped_line).to_s.to_i
		top_edge = /(?<=,)(.*)(?=: )/.match(stripped_line).to_s.to_i
		width = /(?<=: )(.*)(?=x)/.match(stripped_line).to_s.to_i
		height = /(?<=x)(.*)/.match(stripped_line).to_s.to_i
		for x in left_edge..(left_edge + width - 1)
			for y in top_edge..(top_edge + height-1)
				if data[x][y] != 1
					this_is_it = false
				end
 			end
		end
		if this_is_it
			puts id
			break
		else
			this_is_it = true
		end
	end
end