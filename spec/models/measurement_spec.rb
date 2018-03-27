require 'rails_helper'

describe Measurement do
  it { is_expected.to belong_to :flux}
  it { is_expected.to belong_to :sample}

  let(:measurement) {FactoryBot.create :measurement}
  it "has millivolts" do
    expect(measurement.respond_to?(:mv)).to eq true
  end

  it "is selectable by compound" do
    compound    = FactoryBot.create :compound, name: "co2"
    measurement = FactoryBot.create :measurement, compound: compound
    flux        = FactoryBot.create :flux, measurements: [measurement]
    expect(Measurement.by_compound('co2')).to include(measurement)
  end

  describe "locating standard curves" do
    before(:each) do
      @compound    = FactoryBot.create :compound, name: "co2"
      @run         = FactoryBot.create :run
      sample       = FactoryBot.create :sample, run: @run
      @curve1      = FactoryBot.create :standard_curve, compound: @compound, acquired_at: Time.now()-2.hours, run: @run, column: 0
      @curve2      = FactoryBot.create :standard_curve, compound: @compound, acquired_at: Time.now()+2.hours, run: @run, column: 0
      @measurement = FactoryBot.create :measurement, compound: @compound, acquired_at: Time.now(), sample: sample, column: 0
    end

    it "ignores later standard curves" do
      FactoryBot.create :standard_curve, compound: @compound, acquired_at: Time.now()+4.hours, run: @run
      expect(@measurement.standard_curves()).to eq [@curve1, @curve2]
    end

    it "ignores earlier standard curves" do
      FactoryBot.create :standard_curve, compound: @compound, acquired_at: Time.now()-4.hours, run: @run
      expect(@measurement.standard_curves()).to eq [@curve1, @curve2]
    end 

    it "ignores other runs curves" do
      run = FactoryBot.create :run
      FactoryBot.create :standard_curve, compound: @compound, acquired_at: Time.now()-4.hours, run: run
      expect(@measurement.standard_curves()).to eq [@curve1, @curve2]
    end

    it "ignores other compounds standard curves" do
      compound    = FactoryBot.create :compound, name: "H"
      FactoryBot.create :standard_curve, compound: compound, acquired_at: Time.now()+4.hours, run: @run
      expect(@measurement.standard_curves()).to eq [@curve1, @curve2]
    end

    it "ignores other columns standard curves" do
      FactoryBot.create :standard_curve, compound: @compound, acquired_at: Time.now()-1.hours, run: @run, column: 1
      expect(@measurement.standard_curves()).to eq [@curve1, @curve2]
    end

    it "returns what is there" do
      @curve2.delete
      expect(@measurement.standard_curves()).to eq [@curve1]
    end

    it "returns nothing if there is nothing" do
      @curve1.delete
      @curve2.delete
      expect(@measurement.standard_curves()).to eq []
    end
  end
end

# == Schema Information
#
# Table name: measurements
#
#  id               :integer          not null, primary key
#  response         :float
#  excluded         :boolean          default("false")
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
