require File.dirname(__FILE__) + '/spec_helper'


describe LevenshteinPuzzle::TreeSolution do
	let(:corpus) { LevenshteinPuzzle::DataCorpus.new.tap { |c| c.root = "causes" } }
	let(:solver) { LevenshteinPuzzle::TreeSolution.new }
	let(:final_network) { { 1 => %w(cause aauses causese), 2 => %w(caus aause)} }
  
  
  describe ".find_all_the_friends!" do
  	context "when simple" do
	  	before do
			  %w(causes cause causese caus aauses aause).each { |word| corpus.send :build_key, word } 
		  	solver.corpus = corpus
		  	solver.find_all_the_friends!
		  end
	    subject { solver.final_network }
	    it { should == final_network }
	  end
	  context "when complex" do
	   	before do
	  		["carnie", "carnied", "carnier", "carnies", "carniest", "carns", "carny", "carp", "carpal", "carpale", "carpals", "carped", "carpel", "carpels", "carper", "carpers", "carpet", "carpets", "carpi", "carps", "carpus", "carr", "carrel", "carrell", "carrells", "carrels", "carried", "carrier", "carriers", "carries", "carrs", "carry", "cars", "carse", "carses", "carsey", "carseys", "cart", "carta", "cartas", "carte", "carted", "cartel", "cartels", "carter", "carters", "cartes", "carts", "carve", "carved", "carvel", "carvels", "carven", "carver", "carvers", "carvery", "carves", "carvies", "carvy", "casa", "casas", "case", "cased", "cases", "cash", "cashaw", "cashaws", "cashed", "cashes", "cashew", "cashews", "cask", "casked", "casket", "caskets", "casks", "casky", "cast", "caste", "casted", "caster", "casters", "castes", "castle", "castled", "castles", "castor", "castors", "castory"].each do |word|
	  			corpus.send :build_key, word
				end
				solver.corpus = corpus
	  		solver.find_all_the_friends!
	  	end
			subject {	solver.final_network }
	  	its([3]) { should include "carnies" }
	  	it "length should be 89" do
	  		solver.final_network.values.flatten.uniq.size.should == 89
	  	end
	  end

  end

  
  describe ".sibblings" do
  	let(:potential_sibblings) {%w(causes cause causese caus aauses aause).map { |word| create_node(word)} }
    before do
    	%w(causes cause causese caus aauses aause cau).each { |word| corpus.send :build_key, word } 
		  solver.corpus = corpus
		  
		  @sibblings = solver.send :potential_sibblings, create_node("cause")
    end
    subject { @sibblings }
    its(:size) { should eql(6)}
    5.times do |i|
    	it { should include potential_sibblings[i] }
    end
  end
  
  describe ".find_friends_for_node" do
  	context "when a very simple case" do
     before do
		  	%w(causes cause causese caus cau).each { |word| corpus.send :build_key, word } 
	  		solver.corpus = corpus
	  		solver.send :find_friends_for_node, create_node("cause", 1)
	  	end
	  	subject { solver.final_network }
	  	its([2]) { should == %w(caus) }
  	end

  end
end
