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
