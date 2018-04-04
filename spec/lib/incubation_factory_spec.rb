# frozen_string_literal: true

require 'rails_helper.rb'

describe IncubationFactory do
  before do
    FactoryBot.create(:compound, name: 'co2')
    FactoryBot.create(:compound, name: 'n2o')
    FactoryBot.create(:compound, name: 'ch4')

    @lid = FactoryBot.create :lid, name: 'C'

    @run = FactoryBot.create :run

    @incubation = IncubationFactory.create(@run.id,
                                           sample_date: '2011-10-18', sub_plot: 'F1',
                                           treatment: 'T6', replicate:  'R1', chamber: '1',
                                           vial: '1', lid: 'C', height: [18, 19.5, 19, 20.5],
                                           soil_temperature: 18.5, seconds: 0.0, comments: nil)
  end

  describe 'no existing incubation' do
    it 'has the right treatment' do
      expect(@incubation.treatment).to eq 'T6'
    end
    it 'has the right replicate' do
      expect(@incubation.replicate).to eq 'R1'
    end
    it 'has the right lid' do
      expect(@incubation.lid).to eq @lid
    end
    it 'has the right chamber' do
      expect(@incubation.chamber).to eq '1'
    end
    it 'has the right height' do
      expect(@incubation.avg_height_cm).to eq 19.25
    end
    it 'has the right sample date' do
      pending 'figure out why it does not set the sample date'
      expect(@incubation.sampled_at).to eq Date.new(2011, 10, 13)
    end
    it 'has 1 sample' do
      expect(@incubation.samples.size).to eq 1
    end
    it 'has a uuid on the sample' do
      expect(@incubation.samples.first.uuid).to_not be_nil
    end
    it 'has 3 fluxes' do
      expect(@incubation.fluxes.size).to eq 3
    end
    it 'has a co2 flux' do
      c = Compound.where(name: 'co2').first
      expect(@incubation.fluxes.where(compound_id: c.id)).to_not be_nil
    end
    it 'has the right vial in the measurements' do
      expect(@incubation.vials.first).to eq '1'
    end
    it 'has the right seconds in the measurement' do
      expect(@incubation.seconds.first).to eq 0
    end
  end

  describe 'if there is one with a different sub_plot level' do
    before do
      @incubation2 = IncubationFactory.create(@run.id,
                                              sample_date: '2011-10-18',
                                              sub_plot: 'F2',
                                              treatment: 'T6', replicate: 'R1',
                                              chamber: '1', vial: '1',
                                              lid: 'C', height: [18, 19.5, 19, 20.5],
                                              soil_temperature: 18.5,
                                              seconds: 0.0, comments: nil)
    end

    it 'creates a new incubation' do
      expect(@incubation2).to_not eq @incubation
    end
  end

  describe 'if there is an existing sample in the run' do
    before do
      @incubation.save
      @existing = @incubation
      @incubation = IncubationFactory.create(@run.id,
                                             sample_date: '2011-10-18',
                                             treatment: 'T6', replicate:  'R1', sub_plot:  'F1',
                                             chamber: '1', vial: '2',
                                             lid: 'C', height: [18, 19.5, 19, 20.5],
                                             soil_temperature: 18.5,
                                             seconds: 20, comments: nil)
    end
    it 'returns the old incubation' do
      expect(@existing).to eq @incubation
    end
    it 'has the right vials' do
      expect(@incubation.vials).to include('2')
    end
    it 'has the right seconds' do
      expect(@incubation.seconds).to include(20)
    end
  end

  describe 'if there is an existing sample in another run' do
    before do
      @incubation.save
      @existing = @incubation
      run = FactoryBot.create :run
      @incubation = IncubationFactory.create(run.id,
                                             sample_date: '2011-10-18',
                                             treatment: 'T6', replicate: 'R1', chamber: '1',
                                             sub_plot: '', vial: '2',
                                             lid: 'C', height: [18, 19.5, 19, 20.5],
                                             soil_temperature:  18.5,
                                             seconds:  20, comments:  nil)
    end

    it 'creates a new incubation' do
      expect(@existing).to_not eq @incubation
    end
  end
end
