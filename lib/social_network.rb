require 'levenshtein'

class String
	def distance? word
		Levenshtein.distance(self, word)
	end
end

module LevenshteinPuzzle

	class DataCorpus
		attr_accessor :lev_dictionary, :root
		def initialize root="causes", file_name=nil
			@lev_dictionary = {}
			@root = root
			load_from_file file_name unless file_name.nil?
		end

		private 
		
		def load_from_file file_name
			File.open(file_name).each_line do |line|
				build_key line.chomp
			end
		end

		def build_key word
			distance = @root.distance?(word)
			node = LevNode.new word, distance
			if @lev_dictionary.has_key? distance
		  	@lev_dictionary[distance] << node
		  else
		  	@lev_dictionary[distance] = [node]
		  end
		end
	end
	class DataCorpusBrutal < DataCorpus
		def build_key word
			distance = @root.distance?(word)
			if @lev_dictionary.has_key? distance
		  	@lev_dictionary[distance] << word
		  else
		  	@lev_dictionary[distance] = [word]
		  end
		end
	end
	class LevNode
		attr_accessor :visited, :word, :level, :distance_from_root
		def initialize word, distance
			@word = word
			@visited = false
			@distance_from_root = distance
		end
		def ==o_node
			word == o_node.word &&
			visited == o_node.visited
		end
		def distance? o_node
			@word.distance? o_node.word
		end
		def visited?
			@visited
		end
		def visit!
			@visited = true
		end
		def <=>node
			@word <=> node.word
		end
	end

	class Solution
		attr_accessor :final_network, :corpus, :root
		def initialize root="causes",file=nil
			@root = root
			@corpus = LevenshteinPuzzle::DataCorpus.new(@root, file) unless file.nil?
			@final_network = {}
		end

	end
	class BrutalTreeSolution < Solution
		def initialize root="causes",file=nil
			@root = root
			@corpus = LevenshteinPuzzle::DataCorpusBrutal.new(@root, file) unless file.nil?
			@data_size = @corpus.lev_dictionary.keys.size
			@final_network = {}
		end

		def find_all_the_friends!
    	@final_network[0] = [@root]
    	level = 0
    	p "here are all the levels : #{@corpus.lev_dictionary.keys.sort}"
    	while !@corpus.lev_dictionary[level].nil?
				level += 1
				p "This is level #{level} from a total of #{@data_size}"
				next unless @corpus.lev_dictionary[level]
				@corpus.lev_dictionary[level].each do |word|
					if @final_network[level - 1]
						smallest_distance = smallest_distance_for_word(word, @final_network[level - 1])
						route_word_to_right_iteration word, smallest_distance, level
					end
				end
			end
		end		


		private
		def smallest_distance_for_word word, sibblings
			smallest_distance = @data_size + 1
			sibblings.each do |node_above|
				dist = word.distance? node_above
				return dist if dist == 1
        if dist < smallest_distance
          smallest_distance = dist
        end
      end
			smallest_distance
		end

		def route_word_to_right_iteration word, smallest_distance, level
      if smallest_distance == 1
      	@final_network[level] ||= []
    		@final_network[level] << word
      elsif smallest_distance == 2
      	@corpus.lev_dictionary[level + 1] ||= []
        @corpus.lev_dictionary[level + 1] << word
      elsif smallest_distance > 2
      	@corpus.lev_dictionary[level + 2] ||= []
        @corpus.lev_dictionary[level + 2] << word
      end
		end
	end

	class TreeSolution < Solution


		def find_all_the_friends!
			@corpus.lev_dictionary[0] = [LevNode.new(@root, 0)]
			find_friends_for_node @corpus.lev_dictionary[0].first
		end
		private
		def find_friends_for_node node
			return if node.visited?
			node.visit!

			@sibblings = potential_sibblings(node)

			@sibblings.each do |node_to_check|
				if !node_to_check.visited? && node.distance?(node_to_check) == 1
					@final_network[node_to_check.distance_from_root] ||= []
					@final_network[node_to_check.distance_from_root] << node_to_check.word
					find_friends_for_node node_to_check
				end
			end unless @sibblings.nil?
				
		end

		def potential_sibblings node
			result = []
			result += @corpus.lev_dictionary[node.distance_from_root] if @corpus.lev_dictionary[node.distance_from_root]
			result += @corpus.lev_dictionary[node.distance_from_root + 1] if @corpus.lev_dictionary[node.distance_from_root + 1]
			result += @corpus.lev_dictionary[node.distance_from_root - 1] if @corpus.lev_dictionary[node.distance_from_root - 1]		
			result
		end
	end

end

solver = LevenshteinPuzzle::BrutalTreeSolution.new "causes", ARGF.filename
solver.find_all_the_friends!

p solver.final_network.values.flatten.uniq.size



