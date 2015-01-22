require File.expand_path("../../../lib/cimmit_setup_parser.rb",__FILE__)

describe CIMMITSetupParser do

  before(:each) do
    parser = CIMMITSetupParser.new(7)
    @data = parser.parse(["101F",1,1,nil,nil,"X",18,15,14,nil,19,0,10,11,10.5,10.2,"comment"])
  end

  it 'produces the right vial id' do
    expect(@data[4]).to eq "S7-CIM-F-101-T1"
  end

  it 'gets the right lid' do
    expect(@data[5]).to eq "X"
  end

  it 'gets the right treatment' do
    expect(@data[0]).to eq "101F"
  end

  it "gets the right replicate" do
    expect(@data[1]).to eq "R1"
  end

  it "gets the right soil tempearture" do
    expect(@data[7]).to eq 19
  end

  it "gets the right height" do
    expect(@data[6]).to eq [18.0, 15.0, 14.0]
  end

  it 'gets the right time' do
    expect(@data[8]).to eq 10.2
  end

  it 'gets the right comment' do
    expect(@data[9]).to eq "comment"
  end

end
