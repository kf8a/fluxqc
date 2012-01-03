require 'spec_helper.rb'
require File.expand_path("../../../lib/incubation_factory.rb",__FILE__)

RESULT1 = RESULT2 = {:treatment => '2', :replicate=>'1',
           :chamber=>'1', :vial => '6',
           :lid => 'D', :height=> [19.5, 19, 19, 19], 
           :soil_temperature => 19,
           :seconds => 20.0, :comments => nil}

describe IncubationFactory do

  describe 'creating a sample' do
    before do
      @incubation = IncubationFactory.create(
          {:plot=> 'T6R1', :chamber=>'1', :vial =>'1',
           :lid=>'C', :height =>[18, 19.5, 19, 20.5], 
           :soil_temperature => 18.5,
           :seconds => 0.0, :comments => nil})
    end
    it 'has the right treatment' do
      @incubation.plot.should == "T6R1"
    end
  end

end
