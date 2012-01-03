require File.expand_path("../../../lib/setup_parser.rb",__FILE__)

RESULT1 = {:treatment => '6', :replicate=>'1', 
           :chamber=>'1', :vial =>'1',
           :lid=>'C', :height =>[18, 19.5, 19, 20.5], 
           :soil_temperature => 18.5,
           :seconds => 0.0, :comments => nil}
RESULT2 = {:treatment => '2', :replicate=>'1',
           :chamber=>'1', :vial => '6',
           :lid => 'D', :height=> [19.5, 19, 19, 19], 
           :soil_temperature => 19,
           :seconds => 20.0, :comments => nil}

describe SetupParser do
  describe 'parsing a csv setup file' do
    before do
      parser = SetupParser.new
      file = File.expand_path("../../data/setup_test.csv", __FILE__)
      File.exists?(file).should be_true
      @result = parser.parse_csv(file)
    end

    it 'returns an array of sample hashes' do
      @result.class.should == Array
    end

    it 'returns the right data for the first row' do
      @result[0].should == RESULT1
    end

    it 'returns the right data for a string treatment' do
      @result[1][:treatment].should == 'DF'
    end

    it 'returns the right data for another row' do
      @result[5].should == RESULT2
    end
  end

  describe 'parsing a xls setup file' do
    before do
      parser = SetupParser.new
      file = File.expand_path("../../data/setup_test.xls", __FILE__)
      File.exists?(file).should be_true
      @result = parser.parse_xls(file)
    end

    it 'returns an array of sample hashes' do
      @result.class.should == Array
    end

    it 'returns the right data for the first row' do
      @result[0].should == RESULT1
    end

    it 'returns the right data for a string treatment' do
      @result[1][:treatment].should == 'DF'
    end
    it 'returns the right data for another row' do
      @result[5].should == RESULT2
    end
  end

end
