require './lib/cimmit_vial.rb'

describe CimmitVial do
  it "deals with a dash and CIM name" do
    expect(CimmitVial.process_cimmit_vial("S3-CIM-B-101-T0")).to eq "S3-CIM-B-101-T0"
  end
  it "deals with a dash and CIM name and space before the B" do
    expect(CimmitVial.process_cimmit_vial("S3-CIM- B-101-T0")).to eq "S3-CIM-B-101-T0"
  end
  it "deals with a dash and a space after the series and no CIM" do
    expect(CimmitVial.process_cimmit_vial("S41- B-101-T2")).to eq "S41-B-101-T2"
  end
  it "deals with a space after CIM" do
    expect(CimmitVial.process_cimmit_vial("S3-CIM B-101-T0")).to eq "S3-CIM-B-101-T0"
  end
  it "deals with a space after CIM-" do
    expect(CimmitVial.process_cimmit_vial("S3-CIM- B-101-T0")).to eq "S3-CIM-B-101-T0"
  end
  it 'recognizes a space after CIM- as a cimmyt vial' do
    expect(CimmitVial.cimmit_vial?("S3-CIM- B-101-T0")).to be_truthy
  end
  it "deals with a dash between the series and the rest" do
    expect(CimmitVial.process_cimmit_vial("S3-F-101-T0")).to eq "S3-F-101-T0"
  end
  it "parses a vial with a series and no dash between the B and the number" do
    expect(CimmitVial.process_cimmit_vial("S38 B-108-T1")).to eq "S38-B-108-T1"
  end
  it "parses a vial with a space between the series and the rest" do
    expect(CimmitVial.process_cimmit_vial("S3 B-102-T0")).to eq "S3-B-102-T0"
  end
end
