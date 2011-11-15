require File.expand_path("../../../lib/data_parser.rb",__FILE__)

describe DataParser do
  describe 'parsing a line of data' do

  end

  describe 'parsing a file of data' do

  end

  it 'parses gc files' do
    parser = DataParser.new
    parser.data = "abc"
    parser.parse.should be_true
  end

end
