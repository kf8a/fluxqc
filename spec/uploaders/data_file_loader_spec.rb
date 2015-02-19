#require File.expand_path("../../../app/uploaders/data_file_loader.rb",__FILE__)
require 'rails_helper'

describe DataFileLoader do

  include ActionDispatch::TestProcess

  before(:all) do
    FactoryGirl.create(:compound, :name=>'co2')
    FactoryGirl.create(:compound, :name=>'n2o')
    FactoryGirl.create(:compound, :name=>'ch4')
  end

  after(:all) do
    Compound.destroy_all
  end


  describe '2011 style data file' do
    before(:all) do
      run = FactoryGirl.create :run
      run.setup_file = fixture_file_upload('/setup_test.csv')
      run.data_files = [fixture_file_upload('2011_results.csv')]
      run.save
      SetupFileLoader.perform(run.id)
      DataFileLoader.perform(run.id)
      @incubation = run.incubations.order(:sampled_at).first
    end

    it 'updates the measurement with the co2 ppm' do
      expect(@incubation.flux('co2').measurements.order(:vial).first.ppm).to eq 431.5
    end
    it 'updates the measurement with the n2o ppm' do
      expect(@incubation.flux('n2o').measurements.order(:vial).first.ppm).to eq 0.361
    end
    it 'updates the measurement with the ch4 ppm' do
      expect(@incubation.flux('ch4').measurements.order(:vial).first.ppm).to eq 1.854
    end
    it 'has a flux' do
      expect(@incubation.flux('ch4')).to_not be_nil
    end
  end

  describe 'a 2010 data file with standards' do
    before do
      run = FactoryGirl.create :run,
                         :data_files => [fixture_file_upload('/glbrc-2010.csv')],
                         :setup_file => fixture_file_upload('/setup_test.csv')

      expect(SetupFileLoader.perform(run.id)).to be_truthy
      expect(DataFileLoader.perform(run.id)).to be_truthy
      @run = Run.find(run.id)
      @run.standard_curves.reload
    end

    it 'has no standard curve' do
      expect(@run.standard_curves.empty?).to eq true
    end
  end

  describe 'a GC data file' do
    before(:all) do
      @run = FactoryGirl.create :run,
                         :data_files => [fixture_file_upload('/2012_result.txt')],
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(@run.id)
      DataFileLoader.perform(@run.id)
      @incubation = @run.incubations.order(:sampled_at).first
      @run.standard_curves.reload
      @measurement = @incubation.flux('n2o').measurements.order(:vial).first
    end

    it 'updateds the acquired time' do
      # Time.zone = 'Eastern Time (US & Canada)'
      expect(@measurement.acquired_at).to eq Time.utc(2012,04,12,21,9,26)
    end
    it 'updates the measurement with the column id' do
      expect(@measurement.column).to eq 1
    end
    it 'updates the measurement with the co2 area' do
      expect(@incubation.flux('co2').measurements.order(:vial).first.area).to eq 70570.75
    end
    it 'updates the measurement with the n2o area' do
      expect(@incubation.flux('n2o').measurements.order(:vial).first.area).to eq 306.040741
    end
    it 'updates the measurement with the ch4 area' do
      expect(@incubation.flux('ch4').measurements.order(:vial).first.area).to eq 20.403509
    end

    it 'keeps standards and check standards' do
      expect(@run.standard_curves.size).to eq 4
    end

    it 'has an n2o standard curve' do
      compound = Compound.find_by(name: 'n2o')
      expect(@run.standard_curves.where(compound_id: compound.id, column: 1).first).to_not be_nil
    end

    it 'loads an area for the n2o standard' do
      compound = Compound.find_by(name: 'n2o')
      curve = @run.standard_curves.find_by(compound_id: compound.id, column: 0)
      expect(curve.standards.first.area).to eq 0
      expect(curve.standards.last.area).to eq 1542.303589
      curve = @run.standard_curves.find_by(compound_id: compound.id, column: 1)
      expect(curve.standards.first.area).to eq 0
      expect(curve.standards.last.area).to eq 1557.262695
    end

    it 'loads ppm into the standard' do
      compound = Compound.find_by(name: 'n2o')
      curve = @run.standard_curves.find_by(compound_id: compound.id, column: 1)
      expect(curve.standards.first.ppm).to eq 0
      expect(curve.standards.last.ppm).to eq 1.678
    end
  end


  describe 'a chemstation file with two standard sets' do
    before(:all) do
      @run = FactoryGirl.create :run,
                         :data_files => [fixture_file_upload('/LTER20130520S4.CSV')],
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(@run.id)
      DataFileLoader.perform(@run.id)
      @incubation = @run.incubations.order(:sampled_at).first
      @run.standard_curves.reload
    end

    it 'has the right number of vials' do
      expect(@run.samples.size).to eq 143
    end

    it 'has two sets of standard curves' do
      expect(@run.standard_curves.size).to eq 8
    end
  end

  describe 'a glbrc chemstation file' do
    before do
      @run = FactoryGirl.create :run,
                         :data_files => [fixture_file_upload('/glbrc-results.CSV')],
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(@run.id)
      DataFileLoader.perform(@run.id)
      @run.standard_curves.reload
    end

    it 'has the right area for vial 2' do
      expect(@run.incubations.where(treatment: "T6").order(:sampled_at).first.flux('ch4').measurements.order(:vial).first.area).to eq 44.905228
    end

  end

  describe  'a 2015 cimmity chemstation file' do
    before do
      @run = FactoryGirl.create :run,
                         :data_files => [fixture_file_upload('/2015-chemstation-results.csv')],
                         :setup_file => fixture_file_upload('/cimmit_setup.csv')
      SetupFileLoader.perform(@run.id)
      DataFileLoader.perform(@run.id)
      @run.standard_curves.reload
    end

    it 'has the right number of samples' do
      expect(@run.samples.size).to eq 44
    end
  end
end
