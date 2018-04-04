require 'rails_helper'

describe Fitter do
  describe 'with valid points' do
    before(:each) do
      fit = Fitter.new
      fit.data = [
        { key: 1, value: 1, deleted: false },
        { key: 2, value: 2, deleted: false }
      ]
      @result = fit.linear_fit
      @slope, @offset, @r2 = fit.linear_fit
    end
    it 'computes the slope' do
      expect(@result[:slope]).to eq 1
    end
    it 'computes r2' do
      expect(@result[:r2]).to eq 1
    end

    it 'computes the offset' do
      expect(@result[:offset]).to eq 0
    end
  end

  describe 'ignoring deleted points' do
    before(:each) do
      fit = Fitter.new
      fit.data = [
        { key: 1, value: 1, deleted: false },
        { key: 2, value: 2, deleted: false },
        { key: 2, value: 4, deleted: true }
      ]
      @result = fit.linear_fit
    end
    it 'computes the slope' do
      expect(@result[:slope]).to eq 1
    end
  end

  describe 'a flux with only deleted points' do
    before(:each) do
      @fit = Fitter.new
      @fit.data = [
        { key: 1, value: 1, deleted: true },
        { key: 2, value: 2, deleted: true },
        { key: 2, value: 4, deleted: true }
      ]
    end
    it 'does not fail' do
      result = { slope: Float::NAN, offset: Float::NAN, r2: Float::NAN }
      expect(@fit.linear_fit).to eq result
    end
  end

  describe 'a flux with missing ppms' do
    before(:each) do
      fit = Fitter.new
      fit.data = [
        { key: 1, value: 1, deleted: false },
        { key: 2, value: nil, deleted: false },
        { key: 2, value: 4, deleted: false }
      ]
      @result = fit.linear_fit
    end

    it 'computes the slope' do
      expect(@result[:slope]).to eq 3
    end
  end

  describe 'a flux with no datapoints' do
    it 'raises an error' do
      fit = Fitter.new
      fit.data = []
      expect { fit.linear_fit }.to raise_error FitterError
    end
  end

  describe 'a flux without times' do
    it 'returns nil' do
      fit = Fitter.new
      fit.data = [
        { key: 1, value: 1, deleted: false },
        { key: 1, value: 2, deleted: false },
        { key: 1, value: 4, deleted: false }
      ]
      expect { fit.linear_fit }.to raise_error FitterError
    end
  end

  describe 'a flux without values' do
    it 'returns nil' do
      fit = Fitter.new
      fit.data = [
        { key: 1, value: 1, deleted: false },
        { key: 2, value: 1, deleted: false },
        { key: 3, value: 1, deleted: false }
      ]
      expect(fit.linear_fit).to include(slope: 0.0, offset: 1.0)
    end
  end

  describe 'a flux with only one datapoint' do
    it 'raises an error' do
      fit = Fitter.new
      fit.data = [{ key: 1, value: 1, deleted: false }]
      expect { fit.linear_fit }.to raise_error FitterError
      # fit.linear_fit == {:slope=>Float::NAN, :offset=>Float::NAN, :r2=>Float::NAN}
    end
  end

  describe 'using a flux object' do
    before(:each) do
      @flux = double
      allow(@flux).to receive(:try).and_return nil
      allow(@flux).to receive(:headspace).and_return(1)
      allow(@flux).to receive(:surface_area).and_return(2)
      allow(@flux).to receive(:mol_weight).and_return(12)
      allow(@flux).to receive(:data).and_return([{ key: 1, value: 1, deleted: false },
                                                 { key: 2, value: 2, deleted: false }])
    end

    it 'computes the flux' do
      fitter = Fitter.new(@flux)
      slope, _r2 = fitter.fit
      expect(slope).to be_within(0.1).of(38_571.43)
    end
  end
end
