require 'spec_helper.rb'
require File.expand_path("../../../lib/incubation_factory.rb",__FILE__)

describe IncubationFactory do

  before do
    Factory(:compound, :name=>'co2')
    Factory(:compound, :name=>'n2o')
    Factory(:compound, :name=>'ch4')

    @lid = FactoryGirl.create :lid, :name => 'C'

    @incubation = IncubationFactory.create(
      {:sample_date => '2011-10-18', 
        :treatment => 'T6', :replicate=> 'R1', :chamber=>'1', :vial =>'1',
        :lid=>'C', :height =>[18, 19.5, 19, 20.5], 
        :soil_temperature => 18.5,
        :seconds => 0.0, :comments => nil})
  end

  describe 'if there is no existing incubation' do

    describe 'creating a sample' do
      it 'has the right treatment' do
        @incubation.treatment.should == "T6"
      end
      it 'has the right replicate' do
        @incubation.replicate.should == 'R1'
      end
      it 'has the right lid' do
        @incubation.lid.should  == @lid
      end
      it 'has the right chamber' do
        @incubation.chamber.should  == '1'
      end
      it 'has the right height' do
        @incubation.average_height_cm.should == 19.25
      end
      it 'has the right sample date' do
        @incubation.sampled_at = '2011-10-13'
      end
      it 'should have 3 fluxes' do
        @incubation.fluxes.size.should == 3
      end
      it 'should have a co2 flux' do
        @incubation.fluxes('co2').should_not be_nil
      end
      it 'has the right vial in the measurements' do
        @incubation.vials.first.should == '1'
      end
      it 'has the right seconds in the measurement' do
        @incubation.seconds.first.should == 0
      end
    end

  end

  describe 'if there is an existing sample' do
    describe 'creating a sample' do
      before do
        @incubation.save
        @existing = @incubation
        @incubation = IncubationFactory.create(
          {:sample_date => '2011-10-18', 
            :treatment => 'T6', :replicate=> 'R1', :chamber=>'1', :vial =>'2',
            :lid=>'C', :height =>[18, 19.5, 19, 20.5], 
            :soil_temperature => 18.5,
            :seconds => 20, :comments => nil})
      end
      it 'returns the old incubation' do
        @existing.should == @incubation
      end
      it 'has the right vials' do
        @incubation.vials.include?('2').should be_true
      end
    end

  end

end
