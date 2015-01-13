require 'spec_helper'

describe Compound do
  it {should have_many :measurements}
  it {should have_many :standards}

  let(:compound) {Compound.new(:name=>'co2', :ymax=>8000) }
  it 'returns the default max values' do
  end

  it 'returns the mol_weight' do
    compound.respond_to?(:mol_weight).should eq true 
  end
end

# == Schema Information
#
# Table name: compounds
#
#  id         :integer          not null, primary key
#  name       :string(10)
#  mol_weight :float
#  unit       :string(255)
#  ymax       :float
#  ymin       :float
#
