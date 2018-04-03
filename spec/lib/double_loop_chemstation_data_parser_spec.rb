# frozen_string_literal: true

require 'rails_helper'

describe DoubleLoopChemstationDataParser do
  describe 'parsing a double loop injection file' do
    lines =
      [
        ['4/12/2017 2:16', '147', '12-Apr-17, 02:14:21', 'LTER-S1-127', 'CO2',
         '0', '0', '0', 'CH4', '1.936469', '23.42835', '2.174213', 'N2O', '0',
         '0', '0', 'AutoInt', 'C:\Chem32\1\Data\CIMMYT20170407S1AGC\LTER-S18-206.D', nil],
        ['4/12/2017 19:14', '147', '12-Apr-17, 19:10:14', 'B-LTER-S1-127', 'CO2', '0.588483',
         '84292.85156', 304.30469, 'CH4', '0', '0', '0', 'N2O', '2.421643', '424.875671',
         '0.363388', 'AutoInt', 'C:\Chem32\1\Data\CIMMYT20170407S1AGC\B-LTER-S18-127.D', nil]
      ]

    let(:vials) { DoubleLoopChemstationDataParser.new.parse(lines) }
    let(:test) { vials.first }

    it 'returns one vial' do
      expect(vials.size).to eq 1
    end
    it 'parses the vial correctly' do
      expect(test[:vial]).to eq '127'
    end
    it 'parses co2 correctly' do
      expect(test[:co2][:area]).to eq 84_292.85156
    end
    it 'parses ch4 correctly' do
      expect(test[:ch4][:area]).to eq 23.42835
    end
    it 'parses n2o correctly' do
      expect(test[:n2o][:area]).to eq 424.875671
    end
  end
end
