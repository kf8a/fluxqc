require 'spec_helper'

describe Incubation do
  it {should have_many :fluxes}
  it {should belong_to :run}
  it {should belong_to :lid}

  let(:incubation) {Incubation.new}
  it 'has some headspace' do
    incubation.respond_to?(:headspace).should be_true
  end

  describe 'an incubation with fluxes' do
    before(:each) do
      co2 = FactoryGirl.create(:compound, :name=>'co2')
      n2o = FactoryGirl.create(:compound, :name=>'n2o')

      sample          = FactoryGirl.create(:sample)
      co2_measurement = FactoryGirl.create :measurement,
                                           :compound => co2,
                                           :sample => sample
      n2o_measurement = FactoryGirl.create :measurement,
                                           :compound => n2o,
                                           :sample => sample

      @co2_flux = Flux.new(:measurements => [co2_measurement])
      @n2o_flux = Flux.new(:measurements => [n2o_measurement])

      incubation.fluxes << @co2_flux
      incubation.fluxes << @n2o_flux
      incubation.save
    end

    it 'has vials' do
      incubation.vials.respond_to?('[]').should be_true
    end

    describe 'selecting a specific flux' do

      it 'returns the right flux for the co2 flux' do
        incubation.flux('co2').should == @co2_flux
      end
      it 'returns the right flux for the n2o flux' do
        incubation.flux('n2o').should == @n2o_flux
      end

    end
  end

  describe 'headspace calculation' do
    before(:each) do
      @incubation = Incubation.new
    end
    context 'glbrc lids' do
      before(:each) do
        lid = Lid.new
        lid.stub(:name).and_return('Y')
        @incubation.lid = lid
      end
      it 'returns the right headspace for lid Y' do
        @incubation.avg_height_cm = 19
        @incubation.headspace.should be_within(0.1).of(11.74)
      end
      it 'returns the right headspace for lid Y' do
        @incubation.avg_height_cm = 123
        @incubation.headspace.should be_within(0.1).of(76.69)
      end
    end
    context 'cimmyt lids' do
      before(:each) do
        lid = Lid.new
        lid.stub(:name).and_return('X')
        @incubation.lid = lid
      end
      it 'returns the right headspace for lid X' do
        @incubation.avg_height_cm = 20
        @incubation.headspace.should be_within(0.1).of(9.8)
      end
    end
  end
end

# == Schema Information
#
# Table name: incubations
#
#  id               :integer          not null, primary key
#  sampled_at       :datetime
#  chamber          :string(255)
#  treatment        :string(255)
#  replicate        :string(255)
#  soil_temperature :float
#  avg_height_cm    :float
#  lid_id           :integer
#  run_id           :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

