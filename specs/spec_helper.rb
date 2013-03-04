require File.dirname(__FILE__) + "/../lib/social_network"


def create_node name, distance=1
	LevenshteinPuzzle::LevNode.new name, distance
end