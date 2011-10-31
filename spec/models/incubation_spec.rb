require 'spec_helper'

describe Incubation do
  it {should have_many :fluxes}
  
  describe 'selecting a specific flux' do
    before(:each) do
      @incubation = Incubation.new
      @co2_flux = Flux.new(:compound => 'co2')
      @incubation.fluxes << @co2_flux
      @n2o_flux = Flux.new(:compound => 'n2o')
      @incubation.fluxes << @n2o_flux
      @incubation.save
    end

    it 'should return the right flux for the co2 flux' do
      @incubation.flux('co2').should == @co2_flux
    end
    it 'should return the right flux for the n2o flux' do
      @incubation.flux('n2o').should == @n2o_flux
    end
  end
end
