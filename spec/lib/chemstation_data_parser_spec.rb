# frozen_string_literal: true

require 'rails_helper'

describe ChemstationDataParser do

  describe 'parsing a CIMMYT result file' do
    before do
      @parser = ChemstationDataParser.new
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
end
