require 'spec_helper'

describe Sample do
  it {should have_many :measurements}
  it {should belong_to :run}

  let(:sample) {Sample.create}
  it 'reports its data for a compound' do
    compound    = FactoryGirl.create(:compound, :name=>'co2')
    measurement = FactoryGirl.create(:measurement, :compound=> compound)
    sample.measurements << measurement
    sample.data('co2')== measurement
  end

  it 'has a uuid' do
    sample.uuid.should_not be_nil
  end

  it 'keeps the sampe uuid' do
    uuid = sample.uuid
    sample.save
    sample.uuid.should == uuid
    sample.save
    sample.uuid.should == uuid
  end

  it 'finds the right standards to compute the ppms for its measurements' do
    pending
  end
end

# == Schema Information
#
# Table name: samples
#
#  id            :integer          not null, primary key
#  vial          :string(255)
#  run_id        :integer
#  sampled_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  uuid          :string(255)
#  incubation_id :integer
#

