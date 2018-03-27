#require File.expand_path("../../../app/uploaders/setup_file_loader.rb",__FILE__)
require 'rails_helper'

# class Run
# end

# class SetupParser
# end

describe SetupFileLoader do

  include ActionDispatch::TestProcess

  before do
    ['co2','n2o','ch4'].collect do |name|
      FactoryBot.create(:compound, :name=>name)
    end

  end

  context 'standard file' do

    before do

      run = FactoryBot.create :run,
        :setup_file => fixture_file_upload('/setup_test.csv')

      expect(SetupFileLoader.perform(run.id)).to_not eq false
      @run = Run.find(run.id)
    end

    it 'creates incubations' do
      expect(@run.incubations.size).to eq 36
    end

    it 'creates samples' do
      expect(@run.samples.size).to eq 143
    end

    it 'adds compounds to all of the measurements' do
      @run.samples.collect do |s|
        s.measurements.collect {|m| p s unless m.compound.present? }
      end

      samples = @run.samples.collect do |s|
        s.measurements.collect {|m| m.compound.present? }
      end
      expect(samples.flatten).to_not include(false)
    end

    it 'has 4 vials for the first incubation' do
      expect(@run.incubations.first.flux('n2o').measurements.count).to eq 4
    end

    it 'has the vial 1 for the first sample' do
      expect(@run.incubations.first.samples.first.vial).to eq "45"
    end

    it 'sets the sampled_on field' do
      expect(@run.sampled_on).to eq Date.new(2011,8,19)
    end

    it 'sets the run name' do
      expect(@run.name).to eq 'LTER 2011 Series 10'
    end

    it 'sets the run study' do
      expect(@run.study).to eq 'lter'
    end

  end

  context 'cimmit file' do
    before do

      run = FactoryBot.create :run,
        # :setup_file => fixture_file_upload('/cimmit_setup.csv')
        :setup_file => fixture_file_upload('/cimmyt-2015.csv')

      expect(SetupFileLoader.perform(run.id)).to_not eq false
      @run = Run.find(run.id)
    end

    it 'sets the sampled_on field' do
      expect(@run.sampled_on).to eq Date.new(2015,3,2)
    end

  end

end
