require 'spec_helper'

describe Sample do
  it {should have_many :measurements}
  it {should belong_to :run}
  it {should have_many :standard_curves}

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

  describe 'standard curves' do
    before(:each) do
      run = Run.create
      standard_curve_1 = StandardCurve.create({sampled_at: Time.now() - 2.hour, run_id: run.id})
      @standard_curve_2 = StandardCurve.create({sampled_at: Time.now() - 1.hour, run_id: run.id})
      @standard_curve_3 = StandardCurve.create({sampled_at: Time.now() + 1.hour, run_id: run.id})
      standard_curve_4 = StandardCurve.create({sampled_at: Time.now() + 2.hour, run_id: run.id})
      @sample = Sample.new({sampled_at: Time.now(), run_id: run.id})
    end

    it "finds the right standard_curves" do
      @sample.find_standard_curves.should == [@standard_curve_2, @standard_curve_3]
    end

    it "attaches the standard curve" do
      @sample.attach_standard_curves
      @sample.standard_curves.should == [@standard_curve_2, @standard_curve_3]
    end
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

