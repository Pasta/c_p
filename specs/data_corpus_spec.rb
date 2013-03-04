require File.dirname(__FILE__) + '/spec_helper'

describe LevenshteinPuzzle::DataCorpus do


	describe "#build_key" do
	  before do
	    @corpus = LevenshteinPuzzle::DataCorpus.new
	    %w(causes cause causese caus aauses).each { |word| @corpus.send :build_key, word } 
	  end
   	subject { @corpus.lev_dictionary }
  	its(:keys) { should have(3).key}
	end


	
	describe "#load_from_file" do
	  before do 
	  	@corpus = LevenshteinPuzzle::DataCorpus.new
	  	@corpus.send :load_from_file, File.dirname(__FILE__) + "/fixtures/simple_example.txt"
	  end
	  subject { @corpus.lev_dictionary }
	  its(:keys) { should have(3).key}
	end

end