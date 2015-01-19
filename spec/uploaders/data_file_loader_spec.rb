#require File.expand_path("../../../app/uploaders/data_file_loader.rb",__FILE__)
require 'spec_helper'

describe DataFileLoader do

  include ActionDispatch::TestProcess

  before do
    FactoryGirl.create(:compound, :name=>'co2')
    FactoryGirl.create(:compound, :name=>'n2o')
    FactoryGirl.create(:compound, :name=>'ch4')
  end

  describe '2011 style data file' do
    before do
      run = FactoryGirl.create :run,
                    :data_file => fixture_file_upload('/2011_results.csv'),
                    :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(run.id).should_not eq false
      DataFileLoader.perform(run.id).should_not eq false
      @run = Run.find(run.id)
    end

    describe 'when there are measurements available' do
      before do
        @incubation = @run.incubations.first
      end
      it 'updates the measurement with the co2 ppm' do
        @incubation.flux('co2').measurements.first.ppm.should == 431.5
      end
      it 'updates the measurement with the n2o ppm' do
        @incubation.flux('n2o').measurements.first.ppm.should == 0.361
      end
      it 'updates the measurement with the ch4 ppm' do
        @incubation.flux('ch4').measurements.first.ppm.should == 1.854
      end
      it 'has a flux' do
        @incubation.flux('ch4').should_not be_nil
      end
    end
  end

  describe 'a 2010 data file with standards' do
    before do
      run = FactoryGirl.create :run,
                         :data_file => fixture_file_upload('/glbrc-2010.csv'),
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(run.id).should_not eq false
      DataFileLoader.perform(run.id).should_not eq false
      @run = Run.find(run.id)
      @run.standard_curves.reload
    end

    it 'has no standard curve' do
      @run.standard_curves.empty?.should eq true
    end
  end

  describe 'a GC data file' do
    before do
      run = FactoryGirl.create :run,
                         :data_file => fixture_file_upload('/2012_result.txt'),
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(run.id).should_not eq false
      DataFileLoader.perform(run.id).should_not eq false
      @run = Run.find(run.id)
      @incubation = @run.incubations.first
      @run.standard_curves.reload
    end

    it 'updateds the acquired time' do
			Time.zone = 'Eastern Time (US & Canada)' 
      #@incubation.flux('n2o').measurements.first.acquired_at.should == Time.zone.local(2012,04,12,21,3,35)
      expect(@incubation.flux('n2o').measurements.first.acquired_at).to eq Time.zone.local(2012,04,12,21,3,35)
    end
    it 'updates the measurement with the column id' do
      expect(@incubation.flux('n2o').measurements.first.column).to eq 1
    end
    it 'updates the measurement with the co2 area' do
      expect(@incubation.flux('co2').measurements.first.area).to eq 70570.75
    end
    it 'updates the measurement with the n2o area' do
      expect(@incubation.flux('n2o').measurements.first.area).to eq 306.040741
    end
    it 'updates the measurement with the ch4 area' do
      expect(@incubation.flux('ch4').measurements.first.area).to eq 20.403509
    end

    it 'keeps standards and check standards' do
      @run.standard_curves.size.should == 4
    end

    it 'has an n2o standard curve' do
      compound = Compound.find_by(name: 'n2o')
      @run.standard_curves.where(compound_id: compound.id, column: 1).first.should_not be_nil
    end

    it 'loads an area for the n2o standard' do
      compound = Compound.find_by(name: 'n2o')
      curve = @run.standard_curves.find_by(compound_id: compound.id, column: 0)
      curve.standards.first.area.should == 0
      curve.standards.last.area.should == 1542.303589
      curve = @run.standard_curves.find_by(compound_id: compound.id, column: 1)
      curve.standards.first.area.should == 0
      curve.standards.last.area.should == 1557.262695
    end

    it 'loads ppm into the standard' do
      compound = Compound.find_by(name: 'n2o')
      curve = @run.standard_curves.find_by(compound_id: compound.id, column: 1)
      curve.standards.first.ppm.should == 0
      curve.standards.last.ppm.should == 1.678
    end
  end


  describe 'a chemstation file with two standard sets' do
    before do
      run = FactoryGirl.create :run,
                         :data_file => fixture_file_upload('/LTER20130520S4.CSV'),
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(run.id).should_not eq false
      DataFileLoader.perform(run.id).should_not eq false
      @run = Run.find(run.id)
      @incubation = @run.incubations.first
      @run.standard_curves.reload
    end

    it 'should have the right number of vials' do
      @run.samples.size.should == 143
    end

    it 'should have two sets of standard curves' do
      @run.standard_curves.size.should == 8
    end
  end

  describe 'a glbrc chemstation file' do
    before do
      run = FactoryGirl.create :run,
                         :data_file => fixture_file_upload('/glbrc-results.CSV'),
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(run.id).should_not eq false
      DataFileLoader.perform(run.id).should_not eq false
      @run = Run.find(run.id)
      @run.standard_curves.reload
    end

    it 'should have the right area for vial 2' do
      @run.incubations.where(treatment: "T6").first.flux('ch4').measurements.first.area.should == 44.905228
    end

  end
end
