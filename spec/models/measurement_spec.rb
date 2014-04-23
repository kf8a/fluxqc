require 'spec_helper'

describe Measurement do
  it {should belong_to :flux}
  it {should belong_to :sample}

  let(:measurement) {FactoryGirl.create :measurement}
  it "should have millivolts" do
    measurement.respond_to?(:mv).should be_true
  end

  it 'is selectable by compound' do
    compound    = FactoryGirl.create :compound, :name=>'co2'
    measurement = FactoryGirl.create :measurement, :compound => compound
    flux        = FactoryGirl.create :flux, :measurements => [measurement]
    Measurement.by_compound('co2').include?(measurement).should be_true
  end
end

# == Schema Information
#
# Table name: measurements
#
#  id               :integer          not null, primary key
#  response         :float
#  excluded         :boolean          default(FALSE)
#  flux_id          :integer
#  seconds          :integer
#  ppm              :float
#  comment          :string(255)
#  vial             :integer
#  run_id           :integer
#  compound_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  area             :float
#  type             :string(255)
#  starting_time    :datetime
#  ending_time      :datetime
#  sample_id        :integer
#  column           :integer
#  acquired_at      :datetime
#  original_seconds :integer
#
# Indexes
#
#  index_measurements_on_compound_id  (compound_id)
#  index_measurements_on_sample_id    (sample_id)
#  sample_flux_id                     (flux_id)
#  sample_run_id                      (run_id)
#
