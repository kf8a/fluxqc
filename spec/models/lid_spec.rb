require 'spec_helper'

describe Lid do
  it {should have_many :incubations}

  let(:lid) {Lid.new}

  it 'should have a surface area' do
    lid.respond_to?(:surface_area).should be_true
  end
end
