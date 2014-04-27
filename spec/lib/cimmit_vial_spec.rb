require './lib/cimmit_vial.rb'

describe CimmitVial do
  it "deals with a dash and CIM name" do
    CimmitVial.process_cimmit_vial("S3-CIM-B-101-T0").should == "S3-CIM-B-101-T0"
  end
  it "deals with a dash and CIM name and space before the B" do
    CimmitVial.process_cimmit_vial("S3-CIM- B-101-T0").should == "S3-CIM-B-101-T0"
  end
  it "deals with a dash and a space after the series and no CIM" do
    CimmitVial.process_cimmit_vial("S41- B-101-T2").should == "S41-B-101-T2"
  end
  it "deals with a space after CIM" do
    CimmitVial.process_cimmit_vial("S3-CIM B-101-T0").should == "S3-CIM-B-101-T0"
  end
  it "deals with a dash between the series and the rest" do
    CimmitVial.process_cimmit_vial("S3-F-101-T0").should == "S3-F-101-T0"
  end
  it "parses a vial with a series and no dash between the B and the number" do
    CimmitVial.process_cimmit_vial("S38 B-108-T1").should == "S38-B-108-T1"
  end
  it "should parse a vial with a space between the series and the rest" do
    CimmitVial.process_cimmit_vial("S3 B-102-T0").should == "S3-B-102-T0"
  end
end
