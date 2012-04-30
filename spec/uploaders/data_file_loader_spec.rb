#require File.expand_path("../../../app/uploaders/data_file_loader.rb",__FILE__)
require 'spec_helper'

describe DataFileLoader do

  include ActionDispatch::TestProcess

  before do
    FactoryGirl.create(:compound, :name=>'co2')
    FactoryGirl.create(:compound, :name=>'n2o')
    FactoryGirl.create(:compound, :name=>'ch4')
  end

  # describe '2011 style data file' do
  #   before do
  #     run = FactoryGirl.create :run,
  #                               :data_file => fixture_file_upload('/2011_results.csv'),
  #                               :setup_file => fixture_file_upload('/setup_test.csv')
  #     SetupFileLoader.perform(run.id).should_not be_false
  #     DataFileLoader.perform(run.id).should_not be_false
  #     @run = Run.find(run.id)
  #   end

  #   describe 'when there are measurements available' do
  #     before do
  #       @incubation = @run.incubations.first
  #     end
  #     it 'updates the measurement with the co2 ppm' do
  #       @incubation.flux('co2').measurements.first.ppm.should == 431.5
  #     end
  #     it 'updates the measurement with the n2o ppm' do
  #       @incubation.flux('n2o').measurements.first.ppm.should == 0.361
  #     end
  #     it 'updates the measurement with the ch4 ppm' do
  #       @incubation.flux('ch4').measurements.first.ppm.should == 1.854
  #     end
  #     it 'has a flux' do
  #       @incubation.flux('ch4').should_not be_nil
  #       @incubation.flux('ch4').value.should_not be_nil
  #     end
  #   end
  # end

  describe 'a GC data file' do
    before do
      run = FactoryGirl.create :run,
                         :data_file => fixture_file_upload('/result.txt'),
                         :setup_file => fixture_file_upload('/setup_test.csv')
      SetupFileLoader.perform(run.id).should_not be_false
      DataFileLoader.perform(run.id).should_not be_false
      @run = Run.find(run.id)
      @incubation = @run.incubations.first
      @standards = @run.standards
    end

    it 'updates the measurement with the co2 area' do
      @incubation.flux('co2').measurements.first.area.should == 32926.003906
    end
    it 'updates the measurement with the n2o area' do
      @incubation.flux('n2o').measurements.first.area.should == 372.076477
    end
    it 'updates the measurement with the ch4 area' do
      @incubation.flux('ch4').measurements.first.area.should == 27.884953
    end

    it 'keeps standards and check standards' do
      @run.standards.reload
      @run.standards.size.should == 3
    end
  end

end
