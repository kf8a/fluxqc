require 'rails_helper'

describe Standardizer do
  let(:st) { Standardizer.new }

  it 'should take standard curves' do
    st = Standardizer.new
    st.standard_curves = []
    expect(st.standard_curves).to eq []
  end

  describe 'to_ppm' do
    describe 'without standard curves' do
      it 'returns nil unless we have standard curves' do
        m = Measurement.new
        allow(m).to receive(:area).and_return(100.0)
        st.to_ppm(m)
        expect(m.ppm).to eq nil
      end
    end

    describe 'with standard curves' do
      before do
        @curve1 = StandardCurve.new
        allow(@curve1).to receive(:slope).and_return(2)
        allow(@curve1).to receive(:intercept).and_return(1)
        st.standard_curves = [@curve1]

        @m = Measurement.new
        allow(@m).to receive(:area).and_return(100.0)
      end

      it 'computes ppm from one standard curve' do
        st.to_ppm(@m)
        expect(@m.ppm).to eq 201.0
      end

      it 'computes ppm from two standard curves as the average' do
        curve2 = StandardCurve.new
        allow(curve2).to receive(:slope).and_return(4)
        allow(curve2).to receive(:intercept).and_return(1)
        st.standard_curves = [@curve1, curve2]

        st.to_ppm(@m)
        expect(@m.ppm).to eq 301.0
      end

      it 'computes ppm from two curves with drift correction' do 
        curve2 = StandardCurve.new
        allow(curve2).to receive(:slope).and_return(4)
        allow(curve2).to receive(:intercept).and_return(1)

        allow(@curve1).to receive(:position).and_return(1)
        allow(curve2).to receive(:position).and_return(10)
        st.standard_curves = [@curve1, curve2]

        allow(@m).to receive(:position).and_return(3)

        st.to_ppm_with_drift_correction(@m)
        expect(@m.ppm).to be_within(0.1).of(245.44)
      end
    end
  end
end
