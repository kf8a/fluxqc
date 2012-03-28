require 'spec_helper'

describe Sample do
  it {should have_many :measurements}
  it {should belong_to :run}

  let(:sample) {Sample.create}
  it 'reports its data for a compound' do
    compound    = Factory(:compound, :name=>'co2')
    measurement = Factory(:measurement, :compound=> compound)
    sample.measurements << measurement
    sample.data('co2').first == measurement
  end
end