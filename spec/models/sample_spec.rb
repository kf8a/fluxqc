require 'rails_helper'

describe Sample do
  it {is_expected.to have_many :measurements}
  it {is_expected.to belong_to :run}
  it {is_expected.to have_many :standard_curves}

  let(:sample) {Sample.create}
  it 'reports its data for a compound' do
    compound    = FactoryBot.create(:compound, :name=>'co2')
    measurement = FactoryBot.create(:measurement, :compound=> compound)
    sample.measurements << measurement
    sample.data('co2')== measurement
  end

  it 'has a uuid' do
    expect(sample.uuid).to_not be_nil
  end

  it 'keeps the sampe uuid' do
    uuid = sample.uuid
    sample.save
    expect(sample.uuid).to eq uuid
    sample.save
    expect(sample.uuid).to eq uuid
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
# Indexes
#
#  index_samples_on_incubation_id  (incubation_id)
#  samples_run_id_vial_key         (run_id,vial) UNIQUE
#
