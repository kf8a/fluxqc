require File.expand_path("../../../lib/data_parser.rb",__FILE__)

describe DataParser do
  describe 'parsing a line of data' do
    it 'is succesful' do
      parser = DataParser.new
      data = "19 09/26/11 11:24:15 AM  18  26-Sep-11, 11:18:46 4 CH4 0.363163  38.807774 38.807774 co2 1.991239  71590.445312  71590.445312  N2O 4.327775  388.435394  388.435394  AutoInt Z:\GLBR    C SER11 092611 TRY3\GLBRC SER11 092611 TRY3 2011-09-26 09-19-16\4.D"
      parser.parse_line(data).should == {:vial=>4, :ch4=>{:value => 38.807774}, :co2=>{:value => 71590.445312}, :n2o=>{:value=>388.435394} } 
    end

  end

  describe 'parsing a file of data' do

  end

  it 'parses gc files' do
    parser = DataParser.new
    parser.data = "abc"
    parser.parse.should be_true
  end

end
