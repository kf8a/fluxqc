require 'spec_helper'

describe Compound do
  it {should have_many :measurements}
  it {should have_many :standards}

  let(:compound) {Compound.new(:name=>'co2', :ymax=>8000) }
  it 'returns the default max values' do
  end

  it 'returns the mol_weight' do
    compound.respond_to?(:mol_weight).should be_true
  end
end
