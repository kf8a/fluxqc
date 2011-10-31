require 'spec_helper'

describe Flux do
  it {should belong_to :incubation}
  it {should have_many :measurements}

  describe 'data retrieval' do
    before(:each) do
      @flux = Flux.new
      measurement =  Measurement.new
      measurement.stub(:seconds).and_return(1)
      measurement.stub(:ppm).and_return(10)
      @flux.measurements << measurement
    end

    it 'should return a list of seconds and ppm' do
      @flux.data.should == [{key:1,value:10}]
    end
  end
end
