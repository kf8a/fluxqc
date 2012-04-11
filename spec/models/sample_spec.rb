require 'spec_helper'

describe Sample do
  it {should have_many :measurements}
  it {should belong_to :run}

  let(:sample) {Sample.create}
  it 'reports its data for a compound' do
    compound    = FactoryGirl.create(:compound, :name=>'co2')
    measurement = FactoryGirl.create(:measurement, :compound=> compound)
    sample.measurements << measurement
    sample.data('co2').first == measurement
  end
  
  it 'has a uuid' do
    sample.uuid.should_not be_nil
  end

  it 'keeps the sampe uuid'
end
