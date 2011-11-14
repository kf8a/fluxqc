require 'spec_helper'

describe Flux do
  it {should belong_to :incubation}
  it {should belong_to :compound}
  it {should have_many :measurements}

  let(:flux) {Factory.create :flux}

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
      flux.data.should == [{id:1, key:1,value:10, deleted:false}]
    end
  end

  describe 'data writing' do
    before(:each) do
      @measurement =  Factory.create :measurement
      flux.measurements << @measurement
      flux.data = [{id:@measurement.id,key:4, value:10, deleted:true}]
    end
    it 'should have one measurement' do
      flux.measurements.size.should == 1
    end
    it 'updates the seconds' do
      flux.measurements.first.seconds.should == 4
    end
    it 'updates the ppms' do
      flux.measurements.first.ppm.should == 10
    end
    it 'updates the excluded setting' do
      flux.measurements.first.excluded.should be_true
    end
  end

end
