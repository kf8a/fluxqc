require 'spec_helper'

describe Flux do
  it {should belong_to :incubation}
  it {should belong_to :compound}
  it {should have_many :measurements}

  let(:flux) {Flux.new}

  it 'has methods to make the flux calculation easier' do
    flux.respond_to?(:headspace).should be_true
    flux.respond_to?(:surface_area).should be_true
    flux.respond_to?(:mol_weight).should be_true
  end


  describe 'data retrieval' do
    before(:each) do
      measurement =  Measurement.new
      measurement.stub(:seconds).and_return(1)
      measurement.stub(:ppm).and_return(10)
      measurement.stub(:excluded).and_return(false)
      flux.measurements << measurement
    end

    it 'should return a list of seconds and ppm' do
      flux.data.should == [{id:nil, key:1,value:10, deleted:false}]
    end
  end

  describe 'data setting' do
    before(:each) do
      @measurement =  Factory.create :measurement
      flux.data = [{id:@measurement.id,key:1, value:10, deleted:false}]
    end
    it 'updates the seconds' do
      flux.measurements.first.seconds.should == 1
    end
    it 'updates the ppms' do
      flux.measurements.first.ppm.should == 10
    end
    it 'updates the excluded setting' do
      flux.measurements.first.excluded.should be_false
    end
  end

end
