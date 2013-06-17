require 'spec_helper'

describe Standardizer do
  let(:st) { Standardizer.new }

  it 'should take standard curves' do
    st = Standardizer.new
    st.standard_curves = []
    st.standard_curves.should == []
  end

  describe 'to_ppm' do
    describe 'without standard curves' do
      it 'returns nil unless we have standard curves' do
        m = Measurement.new
        m.stub(:area).and_return(100.0)
        st.to_ppm(m)
        m.ppm.should == nil
      end
    end

    describe 'with standard curves' do
      before do
        @curve1 = StandardCurve.new
        @curve1.stub(:slope).and_return(2)
        @curve1.stub(:intercept).and_return(1)
        st.standard_curves = [@curve1]

        @m = Measurement.new
        @m.stub(:area).and_return(100.0)
      end

      it 'computes ppm from one standard curve' do
        st.to_ppm(@m)
        @m.ppm.should == 201.0
      end

      it 'computes ppm from two standard curves as the average' do
        curve2 = StandardCurve.new
        curve2.stub(:slope).and_return(4)
        curve2.stub(:intercept).and_return(1)
        st.standard_curves = [@curve1, curve2]

        st.to_ppm(@m)
        @m.ppm.should == 301.0
      end

      it 'computes ppm from two curves with drift correction' do 
        curve2 = StandardCurve.new
        curve2.stub(:slope).and_return(4)
        curve2.stub(:intercept).and_return(10)

        @curve1.stub(:position).and_return(1)
        curve2.stub(:position).and_return(10)
        st.standard_curves = [@curve1, curve2]

        @m.stub(:position).and_return(7)

        st.to_ppm_with_drift_correction(@m)
        @m.ppm.should == 351.0
      end
    end
  end
end
