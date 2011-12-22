require 'spec_helper'

describe Measurement do
  it {should belong_to :flux}

  let(:measurement) {Factory.create :measurement}
  it "should have millivolts" do
    measurement.respond_to?(:mv).should be_true
  end
end
