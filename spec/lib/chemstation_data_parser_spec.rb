# frozen_string_literal: true

require 'rails_helper'

describe ChemstationDataParser do
  it 'can tell if we have a chemstation vial' do
    parser = ChemstationDataParser.new
    expect(parser.vial?('13-S7-LTER-243')).to be_truthy
    expect(parser.vial?('13:37:30')).to be_falsy
  end

  describe 'parsing a CIMMYT result file' do
    before do
      @parser = ChemstationDataParser.new
    end

    it 'parses the vial correctly' do
      test_string =
        ['12/07/12 6:49:12 PM', 29, '07-Dec-12, 18:44:16', 'F-107-T0', 'CH4', 0.500317, 22.6583]
      vial = @parser.parse_vial(test_string)
      expect(vial).to eq 'F-107-T0'
    end

    it 'parses a shorted vial correctly' do
      test_string =
        ['12/07/12 6:49:12 PM', 29, '07-Dec-12, 18:44:16', 'B107-T0', 'CH4', 0.500317, 22.6583]
      vial = @parser.parse_vial(test_string)
      expect(vial).to eq 'B-107-T0'
    end

    it 'parses a vial with series correctly' do
      test_string =
        ['12/07/12 6:49:12 PM', 29, '07-Dec-12, 18:44:16', 'S13-CIM-B-107-T0', 'CH4',
         0.500317, 22.6583]
      vial = @parser.parse_vial(test_string)
      expect(vial).to eq 'S13-CIM-B-107-T0'
    end

    describe 'parsing the areas correctly' do
      test_string =
        ['12/07/12 6:49:12 PM', 29, '07-Dec-12, 18:44:16', 'S13-CIM-B-107-T0', 'CH4',
         0.500317, 22.6583, 22.6, 'co2', 100, 200, 200, 'n2o', 4, 40, 40]
      let(:row) { @parser.chemstation_parse(test_string) }
      it 'has the right ch4 area' do
        expect(row[:ch4][:area]).to eq 22.6583
      end
      it 'has the right n2o area' do
        expect(row[:n2o][:area]).to eq 40
      end
      it 'has the right co2 area' do
        expect(row[:co2][:area]).to eq 200
      end
    end

    describe 'parsing a 2015 cemstation line correctly' do
      test_string =
        ['1/10/2014 16:47', '1', '10-Jan-14', ' 16:42:47', 'STD00A', nil, 'CH4',
         '0', '76.270676', '0', 'co2', '0', '151973.625', '0', 'N2O', '0', '428.179932', '0',
         'AutoInt', 'Z:\\CIMMYT20131218AND1222S1S2BENGC\\BENGC 2014-01-10 16-39-36\\STD00A.D',
         nil]
      let(:row) { @parser.chemstation_parse(test_string) }

      it 'has the right ch4 area' do
        expect(row[:ch4][:area]).to eq 76.270676
      end
      it 'hss the right n2o area' do
        expect(row[:n2o][:area]).to eq 428.179932
      end
      it 'has the right co2 area' do
        expect(row[:co2][:area]).to eq 151_973.625
      end
    end
  end

  describe 'time parsing in a cimmit file' do
    before do
      @parser = ChemstationDataParser.new
    end
    it 'parses time correctly' do
      expect(@parser.parse_time('10-Jan-14 16:42:47')).to eq Time.new(2014, 1, 10, 16, 42, 47)
    end
    it 'parses other format' do
      expect(@parser.parse_time('1/10/2014 16:42:47')).to eq Time.new(2014, 1, 10, 16, 42, 47)
    end
    it 'parses other format' do
      expect(@parser.parse_time('01/10/2014 4:42:47 PM')).to eq Time.new(2014, 1, 10, 16, 42, 47)
    end
    it 'parses other format' do
      expect(@parser.parse_time('04/12/12 3:46:15 PM')).to eq Time.new(2012, 4, 12, 15, 46, 15)
    end
  end
end
