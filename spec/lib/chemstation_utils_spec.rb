# frozen_string_literal: true

require 'rails_helper'

describe ChemstationUtils do
  it 'can tell if we have a chemstation vial' do
    expect(ChemstationUtils.vial?('13-S7-LTER-243')).to be_truthy
    expect(ChemstationUtils.vial?('13:37:30')).to be_falsy
  end

  it 'parses a vial with series correctly' do
    test_string =
      ['12/07/12 6:49:12 PM', 29, '07-Dec-12, 18:44:16', 'S13-CIM-B-107-T0', 'CH4',
       0.500317, 22.6583]
    vial = ChemstationUtils.parse_vial(test_string)
    expect(vial).to eq 'S13-CIM-B-107-T0'
  end

  it 'parses a vial with series reversed correctly' do
    test_string =
      ['12/07/12 6:49:12 PM', 29, '07-Dec-12, 18:44:16', 'S13-CIM-107-B-T0', 'CH4',
       0.500317, 22.6583]
    vial = ChemstationUtils.parse_vial(test_string)
    expect(vial).to eq 'S13-CIM-B-107-T0'
  end

  describe 'time parsing in a cimmit file' do
    it 'parses time correctly' do
      expect(ChemstationUtils.parse_time('10-Jan-14 16:42:47')).to eq Time.new(2014, 1, 10, 16, 42, 47)
    end
    it 'parses other format' do
      expect(ChemstationUtils.parse_time('1/10/2014 16:42:47')).to eq Time.new(2014, 1, 10, 16, 42, 47)
    end
    it 'parses other format' do
      expect(ChemstationUtils.parse_time('01/10/2014 4:42:47 PM')).to eq Time.new(2014, 1, 10, 16, 42, 47)
    end
    it 'parses other format' do
      expect(ChemstationUtils.parse_time('04/12/12 3:46:15 PM')).to eq Time.new(2012, 4, 12, 15, 46, 15)
    end
  end
end
