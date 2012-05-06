require 'spec_helper'

describe StandardCurve do
  it {should have_many :standards}
  it {should belong_to :run}
  it {should belong_to :compound}

  let (:standard_curve) {FactoryGirl.create :standard_curve}

  describe 'data retrieval' do
   before(:each) do
     standard = Standard.new
     standard.stub(:area).and_return(10)
     standard.stub(:ppm).and_return(2)
     standard.stub(:excluded).and_return(false)
     standard_curve.standards << standard
   end

   it 'returns a list of areas and ppms' do
     p standard_curve.data
     standard_curve.data[0].should == {id:1, key:10, value:2, deleted: false}
   end
  end
end
