require File.expand_path("../../../lib/cimmit_setup_parser.rb",__FILE__)

describe CIMMITSetupParser do

  before(:each) do
    parser = CIMMITSetupParser.new
    @data = parser.parse(["101F",1,1,nil,nil,"X",18,15,14,nil,19,0,10,11,10.5,10.2,"comment"])
  end

  it 'produces the right vial id' do
    @data[4].should == "F-101-T1"
  end

  it 'gets the right lid' do
    @data[5].should == "X"
  end

  it 'gets the right treatment' do
    @data[0].should == "101F"
  end

  it "gets the right replicate" do
    @data[1].should == "R1"
  end

  it "gets the right soil tempearture" do
    @data[7].should == 19
  end

  it "gets the right height" do
    @data[6].should == [18.0, 15.0, 14.0]
  end

  it 'gets the right time' do
    @data[8].should == 10.2
  end

  it 'gets the right comment' do
    @data[9].should == "comment"
  end

end
