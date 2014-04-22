require './lib/cimmit_vial.rb'

describe CimmitVial do
  it "deals with a dash and CIM name" do
    CimmitVial.process_cimmit_vial("S3-CIM-B-101-T0").should == "S3-CIM-B-101-T0"
  end
  it "deals with a dash between the series and the rest" do
    CimmitVial.process_cimmit_vial("S3-B-101-T0").should == "S3-B-101-T0"
  end
  it "should parse a vial with a space between the series and the rest" do
    CimmitVial.process_cimmit_vial("S3 B-101-T0").should == "S3-B-101-T0"
  end
end
