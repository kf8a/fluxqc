require File.expand_path("../../../lib/setup_parser.rb",__FILE__)

describe SetupParser do
  describe 'parsing a csv setup file' do
    before do
      @parser = SetupParser.new
    end
    it 'should be successful' do
      pending "I'm going to implement the xls first"
      @parser.parse("mysetupfile.csv")
    end
  end

  describe 'parsing a xls setup file' do
    before do
      parser = SetupParser.new
      file = File.expand_path("../../data/test.xls", __FILE__)
      File.exists?(file).should be_true
      @result = parser.parse_xls(file)
    end

    it 'returns an array of sample hashes' do
      @result.class.should == Array
    end

    it 'returns the right data for the first row' do
      @result[0].should == {:treatment => 6.0, :replicate=>1.0, 
                            :chamber=>1.0, :vial =>1.0,
                            :lid=>'C', :height => 19.25, :soil_temperature => 18.5,
                            :seconds => 0.0}
    end
    it 'returns the right data for another row' do
      @result[5].should == {:treatment => 2.0, :replicate=>1.0,
                            :chamber=>1.0, :vial => 6.0,
                            :lid => 'D', :height=> 19.125, :soil_temperature => 19.0,
                            :seconds => 20.0}
    end
  end

end
