require File.expand_path("../../../lib/setup_parser.rb",__FILE__)


describe SetupParser do

  before do
    @result2 = {:sample_date => '2011-08-19 12:00:00 -4000',
                :treatment => 'T2', 
                :replicate => 'R1', 
                :chamber=>'1', 
                :vial => '6',
                :lid => 'D', 
                :height=> [19.5, 19, 19, 19], 
                :soil_temperature => 19,
                :seconds => 20.0, 
                :comments => nil}
  end
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

    describe 'first row' do
      it 'has the right sample date' do
        @result[0][:sample_date].should == Time.parse('2011-8-19 12:00:00')
      end
      it 'has the right treatment' do
        @result[0][:treatment].should == 'T6'
      end
      it 'has the right replicate' do
        @result[0][:replicate].should == 'R1'
      end
      it 'has the right chamber' do
        @result[0][:chamber].should == '1'
      end
      it 'has the right vial' do
        @result[0][:vial].should == '1'
      end
      it 'has the right lid' do
        @result[0][:lid].should == 'C'
      end
      it 'has the right height' do
        @result[0][:height].should == [18, 19.5, 19, 20.5]
      end
      it 'has the right soil_temperature' do
        @result[0][:soil_temperature].should == 18.5
      end
      it 'has the right seconds' do
        @result[0][:seconds].should == 0
      end
    end

    it 'returns the right data for a string treatment second row' do
      @result[1][:treatment].should == 'TDF'
    end

    describe 'other row' do
      it 'has the right sample date' do
        @result[5][:sample_date].should == Time.parse('2011-8-19 12:00:00')
      end
      it 'has the right treatment' do
        @result[5][:treatment].should == 'T2'
      end
      it 'has the right replicate' do
        @result[5][:replicate].should == 'R1'
      end
      it 'has the right chamber' do
        @result[5][:chamber].should == '1'
      end
      it 'has the right vial' do
        @result[5][:vial].should == '6'
      end
      it 'has the right lid' do
        @result[5][:lid].should == 'D'
      end
      it 'has the right height' do
        @result[5][:height].should == [19.5, 19.0, 19.0, 19.0]
      end
      it 'has the right soil_temperature' do
        @result[5][:soil_temperature].should == 19
      end
      it 'has the right seconds' do
        @result[5][:seconds].should == 20 
      end
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

    describe 'first row' do
      it 'has the right sample date' do
        @result[0][:sample_date].should == Time.parse('2011-8-19 12:00:00')
      end
      it 'has the right treatment' do
        @result[0][:treatment].should == 'T6'
      end
      it 'has the right replicate' do
        @result[0][:replicate].should == 'R1'
      end
      it 'has the right chamber' do
        @result[0][:chamber].should == '1'
      end
      it 'has the right vial' do
        @result[0][:vial].should == '1'
      end
      it 'has the right lid' do
        @result[0][:lid].should == 'C'
      end
      it 'has the right height' do
        @result[0][:height].should == [18, 19.5, 19, 20.5]
      end
      it 'has the right soil_temperature' do
        @result[0][:soil_temperature].should == 18.5
      end
      it 'has the right seconds' do
        @result[0][:seconds].should == 0
      end
    end

    it 'returns the right data for a string treatment second row' do
      @result[1][:treatment].should == 'TDF'
    end

    describe 'other row' do
      it 'has the right sample date' do
        @result[5][:sample_date].should == Time.parse('2011-8-19 12:00:00')
      end
      it 'has the right treatment' do
        @result[5][:treatment].should == 'T2'
      end
      it 'has the right replicate' do
        @result[5][:replicate].should == 'R1'
      end
      it 'has the right chamber' do
        @result[5][:chamber].should == '1'
      end
      it 'has the right vial' do
        @result[5][:vial].should == '6'
      end
      it 'has the right lid' do
        @result[5][:lid].should == 'D'
      end
      it 'has the right height' do
        @result[5][:height].should == [19.5, 19.0, 19.0, 19.0]
      end
      it 'has the right soil_temperature' do
        @result[5][:soil_temperature].should == 19
      end
      it 'has the right seconds' do
        @result[5][:seconds].should == 20 
      end
    end
  end

end
