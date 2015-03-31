require 'rails_helper'

describe Incubation do
  it {is_expected.to have_many :fluxes}
  it {is_expected.to belong_to :run}
  it {is_expected.to belong_to :lid}

  let(:incubation) {Incubation.new}
  it 'has some headspace' do
    expect(incubation.respond_to?(:headspace)).to eq true
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
      expect(incubation.vials.respond_to?('[]')).to eq true
    end

    describe 'selecting a specific flux' do

      it 'returns the right flux for the co2 flux' do
        expect(incubation.flux('co2')).to eq @co2_flux
      end
      it 'returns the right flux for the n2o flux' do
        expect(incubation.flux('n2o')).to eq @n2o_flux
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
        allow(lid).to receive(:name).and_return('Y')
        @incubation.lid = lid
      end
      it 'returns the right headspace for lid Y' do
        @incubation.avg_height_cm = 19
        expect(@incubation.headspace).to be_within(0.1).of(11.74)
      end
      it 'returns the right headspace for lid Y' do
        @incubation.avg_height_cm = 123
        expect(@incubation.headspace).to be_within(0.1).of(76.69)
      end
    end
    context 'cimmyt lids' do
      before(:each) do
        lid = Lid.new
        allow(lid).to receive(:name).and_return('X')
        @incubation.lid = lid
      end
      it 'returns the right headspace for lid X' do
        @incubation.avg_height_cm = 20
        expect(@incubation.headspace).to be_within(0.1).of(9.8)
      end
    end
  end

  it 'returns the right measurements' do
    compound = Compound.new
    lid = Lid.new
    measurement = FactoryGirl.build :measurement, compound: compound, area: 100
    incubation  = FactoryGirl.build :incubation, lid: lid
    flux        = FactoryGirl.build :flux, compound: compound
    flux.measurements = [measurement]
    incubation.fluxes = [flux]
    expect(incubation.measurements_for(compound).first).to eq measurement
  end
end

# == Schema Information
#
# Table name: incubations
#
#  id               :integer          not null, primary key
#  name             :string(25)
#  run_id           :integer
#  soil_temperature :float
#  treatment        :string(255)
#  replicate        :string(255)
#  lid_id           :integer
#  chamber          :string(255)
#  avg_height_cm    :float
#  sampled_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  sub_plot         :string(255)
#  comments         :text
#
# Indexes
#
#  incubation_run_id  (run_id)
#
