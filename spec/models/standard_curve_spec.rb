# frozen_string_literal: true

require 'rails_helper'

describe StandardCurve do
  it { is_expected.to have_many :standards }
  it { is_expected.to belong_to :run }
  it { is_expected.to belong_to :compound }
  it { is_expected.to have_many :samples }

  let(:standard_curve) { FactoryBot.create :standard_curve }

  describe 'getting data and computing parameters' do
    before(:each) do
      @standard1 = Standard.new
      allow(@standard1).to receive(:area).and_return(10.0)
      allow(@standard1).to receive(:ppm).and_return(2.0)
      allow(@standard1).to receive(:excluded).and_return(false)

      standard2 = Standard.new
      allow(standard2).to receive(:area).and_return(100.0)
      allow(standard2).to receive(:ppm).and_return(20.0)
      allow(standard2).to receive(:excluded).and_return(false)

      standard_curve.standards = [@standard1, standard2]
    end

    it 'returns a list of areas and ppms' do
      expect(standard_curve.data[0]).to include(id: @standard1.id,
                                                key: 10,
                                                value: 2,
                                                name: nil,
                                                deleted: false)
    end

    it 'returns a fit_line' do
      expect(standard_curve.fit_line).to include(slope: 0.2,
                                                 offset: 0,
                                                 r2: 1)
    end

    it 'sets the slope and intercept' do
      standard_curve.compute!
      expect(standard_curve.slope).to eq 0.2
      expect(standard_curve.intercept).to eq 0
    end
  end

  describe 'another parameter set' do
    before do
      data = [
        [8.940234, 0],
        [26.697727, 0.565],
        [30.303551, 0.806],
        [33.248451, 1.21],
        [38.959995, 1.613],
        [44.405891, 2.419],
        [50.428177, 3.226]
      ]

      standards = data.map do |area, ppm|
        standard = Standard.new
        allow(standard).to receive(:area).and_return(area)
        allow(standard).to receive(:ppm).and_return(ppm)
        standard
      end
      @standard_curve = StandardCurve.new
      @standard_curve.standards << standards
      @standard_curve.compute!
    end

    it 'returns the right slope' do
      expect(@standard_curve.slope).to be_within(0.001).of(0.0778)
    end

    it 'returns the right intercept' do
      expect(@standard_curve.intercept).to be_within(0.01).of(-1.18)
    end

    it 'returns false for all_zero?' do
      expect(@standard_curve.all_zero?).to eq false
    end

    it 'returns something for fit_line' do
      expect(@standard_curve.fit_line[:slope]).to eq 0.07783319452961618
    end

    it 'returns the right thing on compute!' do
      expect(@standard_curve.compute!).to eq [0.07783319452961618, -1.1849844311358793]
    end
  end

  describe 'a curve with all zero areas when the detector failed' do
    before do
      data = [
        [0, 0],
        [0, 0.565],
        [0, 0.806],
        [0, 1.21],
        [0, 1.613],
        [0, 2.419],
        [0, 3.226]
      ]

      standards = data.map do |area, ppm|
        standard = Standard.new
        allow(standard).to receive(:area).and_return(area)
        allow(standard).to receive(:ppm).and_return(ppm)
        standard
      end
      @standard_curve = StandardCurve.new
      @standard_curve.standards << standards
    end

    it 'returns true for all_zero?' do
      expect(@standard_curve.all_zero?).to eq true
    end
  end

  describe 'json output' do
    it 'includes a list of fluxes that are affected by the standard curve'
  end
end
