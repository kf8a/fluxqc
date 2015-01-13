require 'spec_helper'

describe Flux do
  it {should belong_to :incubation}
  it {should have_many :measurements}

  let(:flux) {FactoryGirl.create :flux}

  it 'has methods to make the flux calculation easier' do
    flux.respond_to?(:headspace).should eq true
    flux.respond_to?(:surface_area).should eq true
    flux.respond_to?(:mol_weight).should eq true
  end


  describe 'data retrieval' do
    before(:each) do
      Measurement.any_instance.stub(:standard_curves).and_return(1)
      measurement =  Measurement.new
      measurement.stub(:seconds).and_return(1)
      measurement.stub(:ppm).and_return(10)
      measurement.stub(:excluded).and_return(false)
      flux.measurements << measurement
    end

    it 'should return a list of seconds and ppm' do
      flux.data.should == [{id:1, key:1,value:10, area:nil, deleted:false, std_curve: 1}]
    end
  end

  describe 'data writing' do
    before(:each) do
      Measurement.any_instance.stub(:standard_curves).and_return(1)
      @m1 = FactoryGirl.create :measurement
      @m2 = FactoryGirl.create :measurement
      flux.measurements << @m1
      flux.measurements << @m2
      flux.stub(:headspace).and_return(1)
      flux.stub(:mol_weight).and_return(1)
      flux.stub(:surface_area).and_return(1)
      flux.data = [{id:@m1.id,key:4, value:10, deleted:true}]
    end

    it 'should have one measurement' do
      flux.measurements.size.should == 2
    end

    it 'updates the seconds' do
      flux.measurements.first.seconds.should == 4
    end

    it 'updates the ppms' do
      flux.measurements.first.ppm.should == 10
    end

    it 'updates the excluded setting' do
      flux.measurements.first.excluded.should eq true
    end

    it 'updates the flux' do
      flux.data = [{id:@m1.id, key:1, value:1, deleted:false},
                    {id:@m2.id, key:2,value:2,deleted:false}]
      flux.value.should == 6428.571428571429
    end
  end
end

# == Schema Information
#
# Table name: fluxes
#
#  id            :integer          not null, primary key
#  incubation_id :integer
#  value         :float
#  compound_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  fluxes_incubation_id  (incubation_id)
#
