require 'spec_helper'

describe StandardCurve do
  it {should have_many :standards}
  it {should belong_to :run}
  it {should belong_to :compound}

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
#

