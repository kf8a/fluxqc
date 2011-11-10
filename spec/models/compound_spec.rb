require 'spec_helper'

describe Compound do
  it {should have_many :fluxes}

  let(:compound) {Compound.new(:name=>'co2', :max=>8000) }
  it 'returns the default max values' do
  end
end
