require 'spec_helper'

describe Measurement do
  it {should belong_to :flux}
  it {should belong_to :sample}
  it {should have_many :standard_curves}

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
#  id            :integer          not null, primary key
#  flux_id       :integer
#  compound_id   :integer
#  sample_id     :integer
#  vial          :string(255)
#  seconds       :float
#  ppm           :float
#  area          :float
#  type          :string(255)
#  excluded      :boolean
#  starting_time :datetime
#  ending_time   :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

