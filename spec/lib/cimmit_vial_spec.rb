describe CimmitVial do
  it 'deals with a dash and CIM name' do
    expect(CimmitVial.process_cimmit_vial('S3-CIM-B-101-T0')).to eq 'S3-CIM-B-101-T0'
  end
  it 'deals with a dash and CIM name and space before the B' do
    expect(CimmitVial.process_cimmit_vial('S3-CIM- B-101-T0')).to eq 'S3-CIM-B-101-T0'
  end
  it 'deals with a dash and a space after the series and no CIM' do
    expect(CimmitVial.process_cimmit_vial('S41- B-101-T2')).to eq 'S41-B-101-T2'
  end
  it 'deals with a space after CIM' do
    expect(CimmitVial.process_cimmit_vial('S3-CIM B-101-T0')).to eq 'S3-CIM-B-101-T0'
  end
  it 'deals with a space after CIM-' do
    expect(CimmitVial.process_cimmit_vial('S3-CIM- B-101-T0')).to eq 'S3-CIM-B-101-T0'
  end
  it 'recognizes a space after CIM- as a cimmyt vial' do
    expect(CimmitVial.cimmit_vial?('S3-CIM- B-101-T0')).to be_truthy
  end
  it 'deals with a dash between the series and the rest' do
    expect(CimmitVial.process_cimmit_vial('S3-F-101-T0')).to eq 'S3-F-101-T0'
  end
  it 'parses a vial with a series and no dash between the B and the number' do
    expect(CimmitVial.process_cimmit_vial('S38 B-108-T1')).to eq 'S38-B-108-T1'
  end
  it 'parses a vial with a space between the series and the rest' do
    expect(CimmitVial.process_cimmit_vial('S3 B-102-T0')).to eq 'S3-B-102-T0'
  end
  # TODO: check when it make  a difference
  it 'parses vials with S#-CIM-120-F-T order1' do
    expect(CimmitVial.process_cimmit_vial('S3-CIM-102-F-T0')).to eq 'S3-CIM-F-102-T0'
    expect(CimmitVial.process_cimmit_vial('S30-CIM-102-B-T0')).to eq 'S30-CIM-B-102-T0'
  end
  it 'parses vials with CIM-S3-120-F-T0 order2' do
    expect(CimmitVial.process_cimmit_vial('CIM-S3-102-F-T0')).to eq 'S3-CIM-F-102-T0'
  end
  it 'parses vials with S1-CIM-B-120-T0 order3' do
    expect(CimmitVial.process_cimmit_vial('S1-CIM-B-102-T0')).to eq 'S1-CIM-B-102-T0'
  end
  it 'parses vials with CIM-S1-F-120-T0 order4' do
    expect(CimmitVial.process_cimmit_vial('CIM-S1-F-102-T0')).to eq 'S1-CIM-F-102-T0'
  end
end
