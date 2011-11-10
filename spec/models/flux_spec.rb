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
      flux.measurements << measurement
    end

    it 'should return a list of seconds and ppm' do
      flux.data.should == [{key:1,value:10}]
    end
  end

  describe 'flux calculations' do
    it 'should return the flux' do
      measurement = Measurement.new
      measurement.stub(:seconds).and_return(1)
      measurement.stub(:ppm).and_return(10)
      flux.measurements << measurement
      incubation = Incubation.new
      incubation.stub(:headspace).and_return(1.0)
      lid = Lid.new
      lid.stub(:surface_area).and_return(2.0)
      incubation.lid = lid
      flux.incubation = incubation
      incubation.fluxes << flux
      compound = Compound.new
      compound.stub(:mol_weight).and_return(12.0)
      flux.compound = compound

      flux.flux.should be_within(0.1).of(38571.43)
    end
  end

end
