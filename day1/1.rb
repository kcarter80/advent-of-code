data = []
File.open("input1", "r") do |f|
	f.each_line do |line|
		data.push(line.strip.to_i)
	end
end

frequency = 0
data.each { |a| frequency+=a }
puts frequency