require 'spec_helper'

describe StandardCurve do
  it {should have_many :standards}
  it {should belong_to :run}
  it {should belong_to :compound}
  it {should have_many :samples}

  let (:standard_curve) {FactoryGirl.create :standard_curve}

  describe 'getting data and computing parameters' do
    before(:each) do
      standard1 = Standard.new
      standard1.stub(:area).and_return(10.0)
      standard1.stub(:ppm).and_return(2.0)
      standard1.stub(:excluded).and_return(false)

      standard2 = Standard.new
      standard2.stub(:area).and_return(100.0)
      standard2.stub(:ppm).and_return(20.0)
      standard2.stub(:excluded).and_return(false)

      standard_curve.standards = [standard1, standard2]
    end

    it 'returns a list of areas and ppms' do
      standard_curve.data[0].should == {id:1, key:10, value:2, :name => nil, deleted: false}
    end

    it 'returns a fit_line' do
      standard_curve.fit_line.should == {:slope=>0.2, :offset=>0, :r2=>1}
    end

    it 'sets the slope and intercept' do
      standard_curve.compute!
      standard_curve.slope.should     == 0.2
      standard_curve.intercept.should == 0
    end
  end

  describe 'another parameter set' do
    before do
      data = [
      [8.940234,0],
      [26.697727,0.565],
      [30.303551,0.806],
      [33.248451,1.21],
      [38.959995,1.613],
      [44.405891,2.419],
      [50.428177,3.226]
      ]

      standard_curve = StandardCurve.new
      standards = data.map do |area, ppm| 
        standard = Standard.new
        standard.stub(:area).and_return(area)
        standard.stub(:ppm).and_return(ppm)
        standard
      end
      @standard_curve = StandardCurve.new
      @standard_curve.standards << standards
      @standard_curve.compute!
    end

    it 'returns the right slope' do
      @standard_curve.slope.should be_within(0.001).of(0.0778)
    end

    it 'returns the right intercept' do
      @standard_curve.intercept.should be_within(0.01).of(-1.18)
    end
  end

  describe 'json output' do
    it 'should include a list of fluxes that are affected by the standard curve' do
      pending
    end
  end

end

# == Schema Information
#
# Table name: standard_curves
#
#  id          :integer          not null, primary key
#  run_id      :integer
#  compound_id :integer
#  slope       :float
#  intercept   :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  column      :integer
#  coeff       :string(255)
#  aquired_at  :datetime
#
