require File.dirname(__FILE__) + '/spec_helper'

describe LevenshteinPuzzle::BrutalTreeSolution do
	let(:corpus) { LevenshteinPuzzle::DataCorpusBrutal.new.tap { |c| c.root = "causes" } }
	let(:solver) { LevenshteinPuzzle::BrutalTreeSolution.new }
	let(:final_network) { { 0 => %w(causes), 1 => %w(cause aauses causese), 2 => %w(caus aause)} }
  
  describe ".find_all_the_friends!" do
   	before do
  		["causes", "carnie", "carnied", "carnier", "carnies", "carniest", "carns", "carny", "carp", "carpal", "carpale", "carpals", "carped", "carpel", "carpels", "carper", "carpers", "carpet", "carpets", "carpi", "carps", "carpus", "carr", "carrel", "carrell", "carrells", "carrels", "carried", "carrier", "carriers", "carries", "carrs", "carry", "cars", "carse", "carses", "carsey", "carseys", "cart", "carta", "cartas", "carte", "carted", "cartel", "cartels", "carter", "carters", "cartes", "carts", "carve", "carved", "carvel", "carvels", "carven", "carver", "carvers", "carvery", "carves", "carvies", "carvy", "casa", "casas", "case", "cased", "cases", "cash", "cashaw", "cashaws", "cashed", "cashes", "cashew", "cashews", "cask", "casked", "casket", "caskets", "casks", "casky", "cast", "caste", "casted", "caster", "casters", "castes", "castle", "castled", "castles", "castor", "castors", "castory"].each do |word|
  			corpus.send :build_key, word
			end
			solver.corpus = corpus
  		solver.find_all_the_friends!
  	end
		subject {	solver.final_network }
  	its([4]) { should include "carnies" }
  	it "length should be 89" do
  		solver.final_network.values.flatten.uniq.size.should == 90
  	end
  end

  describe ".smallest_distance_for_word" do
  	before do
  		["carnie", "carnied", "carnier", "carnies", "carniest", "carns", "carny", "carp", "carpal", "carpale", "carpals", "carped", "carpel", "carpels", "carper", "carpers", "carpet", "carpets", "carpi", "carps", "carpus", "carr", "carrel", "carrell", "carrells", "carrels", "carried", "carrier", "carriers", "carries", "carrs", "carry", "cars", "carse", "carses", "carsey", "carseys", "cart", "carta", "cartas", "carte", "carted", "cartel", "cartels", "carter", "carters", "cartes", "carts", "carve", "carved", "carvel", "carvels", "carven", "carver", "carvers", "carvery", "carves", "carvies", "carvy", "casa", "casas", "case", "cased", "cases", "cash", "cashaw", "cashaws", "cashed", "cashes", "cashew", "cashews", "cask", "casked", "casket", "caskets", "casks", "casky", "cast", "caste", "casted", "caster", "casters", "castes", "castle", "castled", "castles", "castor", "castors", "castory"].each do |word|
  			corpus.send :build_key, word
			end
			solver.corpus = corpus
		end
  	context "when smallest is 1" do
  		let(:potential_sibblings) {%w(causes) }
  	  it "should be 1" do
  	  	solver.send(:smallest_distance_for_word, "cause", potential_sibblings).should eql(1)
  	  end
  	end
  	context "when smallest is 2" do
  		let(:potential_sibblings) {%w(causes) }
  	  it "should be 2" do
  	  	solver.send(:smallest_distance_for_word, "caus", potential_sibblings).should eql(2)
  	  end
  	end
	end
	
	describe ".route_word_to_right_iteration" do
		before do
			solver.final_network[1] = []
		end
	  context "when smallest_distance_for_word == 1" do
	    it "should change @final_network of current level by one" do
	    	expect {
	    		solver.send :route_word_to_right_iteration, "word", 1, 1
	    	}.to change{solver.final_network[1].size}.by(1)
	  	end
	  end
		context "when smallest_distance_for_word == 1" do
			before do
	  		["carnie", "carnied", "carnier", "carnies", "carniest", "carns", "carny", "carp", "carpal", "carpale", "carpals", "carped", "carpel", "carpels", "carper", "carpers", "carpet", "carpets", "carpi", "carps", "carpus", "carr", "carrel", "carrell", "carrells", "carrels", "carried", "carrier", "carriers", "carries", "carrs", "carry", "cars", "carse", "carses", "carsey", "carseys", "cart", "carta", "cartas", "carte", "carted", "cartel", "cartels", "carter", "carters", "cartes", "carts", "carve", "carved", "carvel", "carvels", "carven", "carver", "carvers", "carvery", "carves", "carvies", "carvy", "casa", "casas", "case", "cased", "cases", "cash", "cashaw", "cashaws", "cashed", "cashes", "cashew", "cashews", "cask", "casked", "casket", "caskets", "casks", "casky", "cast", "caste", "casted", "caster", "casters", "castes", "castle", "castled", "castles", "castor", "castors", "castory"].each do |word|
	  			corpus.send :build_key, word
				end
				solver.corpus = corpus
			end
	    it "should change next level of tree by one" do
	    	expect {
	    		solver.send :route_word_to_right_iteration, "word", 2, 1
	    	}.to change{solver.corpus.lev_dictionary[2].size}.by(1)
	  	end
	  end


	end

end