#require File.expand_path("../../../app/uploaders/setup_file_loader.rb",__FILE__)
require 'spec_helper'

# class Run 
# end

# class SetupParser
# end

describe SetupFileLoader do

  include ActionDispatch::TestProcess

  before do
    Factory(:compound, :name=>'co2')
    Factory(:compound, :name=>'n2o')
    Factory(:compound, :name=>'ch4')

    @run = FactoryGirl.create :run, :setup_file => fixture_file_upload('/setup_test.csv')
    SetupFileLoader.perform(@run.id).should_not be_false
  end

  it 'creates incubations' do
    @run.incubations.size.should == 37
  end

  it 'has 3 vials for the first incubation' do
    @run.incubations.first.flux('n2o').measurements.count.should == 3
  end

end
