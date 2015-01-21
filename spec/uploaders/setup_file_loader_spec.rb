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
      FactoryGirl.create(:compound, :name=>name)
    end

    run = FactoryGirl.create :run,
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
    samples.flatten.should_not include(false)
  end

  it 'has 4 vials for the first incubation' do
    @run.incubations.first.flux('n2o').measurements.count.should == 4
  end

  it 'has the vial 1 for the first sample' do
    @run.incubations.first.samples.first.vial.should == "45"
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
