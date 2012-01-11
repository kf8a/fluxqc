require 'spec_helper'

describe Measurement do
  it {should belong_to :flux}
  it {should belong_to :sample}

  let(:measurement) {Factory.create :measurement}
  it "should have millivolts" do
    measurement.respond_to?(:mv).should be_true
  end

  it 'is selectable by compound' do
    compound  = Factory.create :compound, :name=>'co2'
    flux      = Factory.create :flux, :compound => compound, :measurements => [measurement]
    Measurement.by_compound('co2').include?(measurement).should be_true
  end
end
