require 'spec_helper.rb'
require File.expand_path("../../../lib/incubation_factory.rb",__FILE__)

describe IncubationFactory do

  describe 'if there is no existing incubation' do

    describe 'creating a sample' do
      before do
        @lid = FactoryGirl.create :lid, :name => 'C'
        @incubation = IncubationFactory.create(
          {:treatment => 'T6', :replicate=> 'R1', :chamber=>'1', :vial =>'1',
            :lid=>'C', :height =>[18, 19.5, 19, 20.5], 
            :soil_temperature => 18.5,
            :seconds => 0.0, :comments => nil})
      end
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
    end

  end

  describe 'if there is an existing sample' do

  end

end
