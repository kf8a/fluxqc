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
      SetupFileLoader.perform(run.id).should_not be_false
      DataFileLoader.perform(run.id).should_not be_false
      @run = Run.find(run.id)
    end

		# describe 'standard curves' do
		# 	it 'has the right number of standard curves' do
		# 		@run.standard_curves.size.should == 6
		# 	end
		# end

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

  describe 'a GC data file' do
    before do
      run = FactoryGirl.create :run,
                         :data_file => fixture_file_upload('/2012_result.txt'),
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(run.id).should_not be_false
      DataFileLoader.perform(run.id).should_not be_false
      @run = Run.find(run.id)
      @incubation = @run.incubations.first
      @run.standard_curves.reload
    end

    it 'updateds the acquired time' do
			Time.zone = 'Eastern Time (US & Canada)' 
      @incubation.flux('n2o').measurements.first.acquired_at.should == Time.zone.local(2012,04,12,21,9,26)
    end
    it 'updates the measurement with the column id' do
      @incubation.flux('n2o').measurements.first.column.should == 1
    end
    it 'updates the measurement with the co2 area' do
      @incubation.flux('co2').measurements.first.area.should == 70570.75
    end
    it 'updates the measurement with the n2o area' do
      @incubation.flux('n2o').measurements.first.area.should == 306.040741
    end
    it 'updates the measurement with the ch4 area' do
      @incubation.flux('ch4').measurements.first.area.should == 20.403509
    end

    it 'keeps standards and check standards' do
      @run.standard_curves.size.should == 3
    end

    it 'loads an area' do
      @run.standard_curves.first.standards.first.area.should == 0
      @run.standard_curves.first.standards.last.area.should == 90863.210937
    end

    it 'loads ppm into the standard' do
      @run.standard_curves.first.standards.first.ppm.should == 0
      @run.standard_curves.first.standards.last.ppm.should == 350.423
    end
  end

end
