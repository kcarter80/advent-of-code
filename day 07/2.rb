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

class Worker
	attr_reader :current_node_name, :start_time

	def initialize
		@current_node_name = nil
	end

	def set_current_node_name(name)
		@current_node_name = name
	end

	def set_start_time(time)
		@start_time = time
	end
end

class JobRunner
	attr_reader :num_workers, :nodes

	def initialize(num_workers, nodes)
		@workers = Array.new(num_workers)
		0.upto(@workers.length-1) do |i|
			@workers[i] = Worker.new
		end
		@nodes = nodes
		@execution_time = 0
		run_jobs
	end

	def run_jobs
		0.upto(@workers.length-1) do |i|
			if !@workers[i].current_node_name
				executable_nodes = @nodes.select{|key, node| node.previous_nodes.length == 0 }.values.sort_by(&:name)
				currently_executing_node_names = @workers.collect { |worker| worker.current_node_name }
				executable_nodes.reject! { |node| currently_executing_node_names.index(node.name) }
				if executable_nodes.length > 0
					@workers[i].set_current_node_name(executable_nodes[0].name)
					@workers[i].set_start_time(@execution_time)
				end
			end
		end
		finished_workers = @workers.reject {|worker| worker.current_node_name.nil?}.group_by{|worker| worker.start_time + worker.current_node_name.ord - 64 }.min.last
		finished_workers.each do |worker|
			@nodes[worker.current_node_name].execute_step
			@nodes.delete(worker.current_node_name)
			@execution_time = worker.start_time + worker.current_node_name.ord - 64 + 60
			worker.set_current_node_name(nil)
			worker.set_start_time(nil)
		end

		if @nodes.length > 0
			run_jobs
		else
			puts @execution_time			
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

JobRunner.new(5,nodes)

