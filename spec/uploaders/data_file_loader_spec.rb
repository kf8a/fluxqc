#require File.expand_path("../../../app/uploaders/data_file_loader.rb",__FILE__)
require 'spec_helper'

describe DataFileLoader do
  
  include ActionDispatch::TestProcess

  before do
    Factory(:compound, :name=>'co2')
    Factory(:compound, :name=>'n2o')
    Factory(:compound, :name=>'ch4')

    run = FactoryGirl.create :run, :data_file => fixture_file_upload('/2011_results.csv'), :setup_file => fixture_file_upload('/setup_test.csv')
    SetupFileLoader.perform(run.id).should_not be_false
    DataFileLoader.perform(run.id).should_not be_false
    @run = Run.find(run.id)
  end

  describe 'when there are measurements available' do
    before do
      @incubation = @run.incubations.first
    end
    it 'updates the measurement with the co2 area' do
      @incubation.flux('co2').measurements.first.ppm.should == 431.5
    end
    it 'updates the measurement with the n2o area' do
      @incubation.flux('n2o').measurements.first.ppm.should == 0.361
    end
    it 'updates the measurement with the ch4 area' do
      @incubation.flux('ch4').measurements.first.ppm.should == 1.854
    end

  end

  describe 'when there are no measurements available' do

  end

end