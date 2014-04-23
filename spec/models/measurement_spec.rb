require 'spec_helper'

describe Measurement do
  it {should belong_to :flux}
  it {should belong_to :sample}

  let(:measurement) {FactoryGirl.create :measurement}
  it "should have millivolts" do
    measurement.respond_to?(:mv).should be_true
  end

  it "is selectable by compound" do
    compound    = FactoryGirl.create :compound, name: "co2"
    measurement = FactoryGirl.create :measurement, compound: compound
    flux        = FactoryGirl.create :flux, measurements: [measurement]
    Measurement.by_compound('co2').include?(measurement).should be_true
  end

  describe "locating standard curves" do
    before(:each) do
      @compound    = FactoryGirl.create :compound, name: "co2"
      @run         = FactoryGirl.create :run
      sample       = FactoryGirl.create :sample, run: @run
      @curve1      = FactoryGirl.create :standard_curve, compound: @compound, acquired_at: Time.now()-2.hours, run: @run, column: 0
      @curve2      = FactoryGirl.create :standard_curve, compound: @compound, acquired_at: Time.now()+2.hours, run: @run, column: 0
      @measurement = FactoryGirl.create :measurement, compound: @compound, acquired_at: Time.now(), sample: sample, column: 0
    end

    it "ignores later standard curves" do
      FactoryGirl.create :standard_curve, compound: @compound, acquired_at: Time.now()+4.hours, run: @run
      @measurement.standard_curves().should == [@curve1, @curve2]
    end

    it "ignores earlier standard curves" do
      FactoryGirl.create :standard_curve, compound: @compound, acquired_at: Time.now()-4.hours, run: @run
      @measurement.standard_curves().should == [@curve1, @curve2]
    end 

    it "ignores other runs curves" do
      run = FactoryGirl.create :run
      FactoryGirl.create :standard_curve, compound: @compound, acquired_at: Time.now()-4.hours, run: run
      @measurement.standard_curves().should == [@curve1, @curve2]
    end

    it "ignores other compounds standard curves" do
      compound    = FactoryGirl.create :compound, name: "H"
      FactoryGirl.create :standard_curve, compound: compound, acquired_at: Time.now()+4.hours, run: @run
      @measurement.standard_curves().should == [@curve1, @curve2]
    end

    it "ignores other columns standard curves" do
      FactoryGirl.create :standard_curve, compound: @compound, acquired_at: Time.now()-1.hours, run: @run, column: 1
      @measurement.standard_curves().should == [@curve1, @curve2]
    end

    it "returns what is there" do
      @curve2.delete
      @measurement.standard_curves().should == [@curve1]
    end

    it "returns nothing if there is nothing" do
      @curve1.delete
      @curve2.delete
      @measurement.standard_curves().should == []
    end
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
