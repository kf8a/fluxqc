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

    run = FactoryGirl.create :run, :setup_file => fixture_file_upload('/setup_test.csv')
    SetupFileLoader.perform(run.id).should_not be_false
    @run = Run.find(run.id)
  end

  it 'creates incubations' do
    @run.incubations.size.should == 37
  end

  it 'has 3 vials for the first incubation' do
    @run.incubations.first.flux('n2o').measurements.count.should == 4
  end

  it 'sets the sampled_on field' do
    @run.sampled_on.should == Date.new(2011,8,19)
  end

  it 'sets the run name' do
    @run.name.should =='LTER 2011 Series 10'
  end

  it 'sets the run study' do
    @run.study.should == 'lter'
  end

end
