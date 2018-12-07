class Node
	attr_reader :name,
		:next_nodes,
		:previous_nodes

	def initialize(name)
		@name = name
		@next_nodes = []
		@previous_nodes = []
	end

	def add_next_node(node)
		@next_nodes.push(node)
	end

	def add_previous_node(node)
		@previous_nodes.push(node)
	end

	def remove_previous_node(node_name_to_remove)
		@previous_nodes.delete_if { |node| node.name == node_name_to_remove }
	end

	def execute_step
		@next_nodes.each do |node|
			node.remove_previous_node(name)
		end
	end
end

nodes = Hash.new

File.open("input7", "r") do |f|
	f.each_line do |line|
		stripped_line = line.strip
		this = /(?<=Step )(.*)(?= must)/.match(stripped_line).to_s
		following = /(?<=step )(.*)(?= can)/.match(stripped_line).to_s
		if !nodes[this]
			nodes[this] = Node.new(this)
		end
		if !nodes[following]
			nodes[following] = Node.new(following)
		end
		nodes[this].add_next_node(nodes[following])
		nodes[following].add_previous_node(nodes[this])
	end
end

while nodes.length > 0
	node = nodes[nodes.select{|key, node| node.previous_nodes.length == 0 }.values.min_by(&:name).name]
	node.execute_step
	nodes.delete(node.name)
	print node.name
end

$stdout.flush
puts ""