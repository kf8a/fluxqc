require 'spec_helper'

describe Incubation do
  it {should have_many :fluxes}
  it {should belong_to :run}
  it {should belong_to :lid}

  let(:incubation) {Incubation.new}
  it 'has some headspace' do
    incubation.respond_to?(:headspace).should be_true
  end
  
  describe 'selecting a specific flux' do
    before(:each) do
      co2 = Factory(:compound, :name=>'co2')
      n2o = Factory(:compound, :name=>'n2o')

      @co2_flux = Flux.new(:compound => co2)
      @n2o_flux = Flux.new(:compound => n2o)

      incubation.fluxes << @co2_flux
      incubation.fluxes << @n2o_flux
      incubation.save
    end

    it 'should return the right flux for the co2 flux' do
      incubation.flux('co2').should == @co2_flux
    end
    it 'should return the right flux for the n2o flux' do
      incubation.flux('n2o').should == @n2o_flux
    end

  end
end
