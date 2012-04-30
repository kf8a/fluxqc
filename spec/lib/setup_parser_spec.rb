require File.expand_path("../../../lib/setup_parser.rb",__FILE__)


describe SetupParser do

  describe 'parsing an lter csv setup file' do
    before do
      file = File.expand_path("../../fixtures/setup_test.csv", __FILE__)
      File.exists?(file).should be_true
      @result = SetupParser.parse(file)
    end

    it 'returns an array of sample hashes' do
      @result.class.should == Array
    end

    it 'has the right run title' do
      @result[0][:run_name].should == 'LTER 2011 Series 10'
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

  describe 'parsing a GLBRC file' do

    before do
      file = File.expand_path("../../fixtures/glbrc_setup.csv", __FILE__)
      File.exists?(file).should be_true
      @result = SetupParser.parse(file)
    end

    it 'has the right title' do
        @result[0][:run_name].should == 'GLBRC 2011 Series 1'
    end

    it 'has the right sample date' do
      @result[0][:sample_date].should == Time.parse('2011-4-7 12:00:00')
    end

    describe 'the first row' do
      it 'is G1' do
        @result[0][:treatment].should == 'G1'
      end
      it 'is lid Y' do
        @result[0][:lid].should == 'Y'
      end
      it 'is rep 1' do
        @result[0][:replicate].should == 'R1'
      end
      it 'is the right height' do
        @result[0][:height].should == [18,17.5,18,17]
      end
      it 'is the right soil temperature' do
        @result[0][:soil_temperature].should == 8
      end
      it 'is the right time' do
        @result[0][:seconds].should == 0
      end
      it 'is the right chamber' do
        @result[0][:chamber].should == "1"
      end
      it 'is the right vial' do
        @result[0][:vial].should == '1'
      end
    end

    describe 'the second row' do
      it 'is G1' do
        @result[1][:treatment].should == 'G1'
      end
      it 'is lid Y' do
        @result[1][:lid].should == 'Y'
      end
      it 'is rep 1' do
        @result[1][:replicate].should == 'R1'
      end
      it 'is the right height' do
        @result[1][:height].should == [18,17.5,18,17]
      end
      it 'is the right soil temperature' do
        @result[1][:soil_temperature].should == 8
      end
      it 'is the right time' do
        @result[1][:seconds].should == 18
      end
      it 'is the right chamber' do
        @result[1][:chamber].should == "1"
      end
      it 'is the right vial' do
        @result[1][:vial].should == '2'
      end
    end
  end

  describe 'parsing a GLBRC scaleup setup file' do

    before do
      file = File.expand_path("../../fixtures/lux_setup.csv", __FILE__)
      File.exists?(file).should be_true
      @result = SetupParser.parse(file)
    end

    it 'has the right title' do
        @result[0][:run_name].should == 'GLBRC 2011 Series 1 Lux Arbor'
    end

    it 'has the right sample date' do
      @result[0][:sample_date].should == Time.parse('2011-4-7 12:00:00')
    end

    describe 'the first row' do
      it 'is G1' do
        @result[0][:treatment].should == 'T1'
      end
      it 'is lid Y' do
        @result[0][:lid].should == 'Y'
      end
      it 'is rep 1' do
        @result[0][:replicate].should == 'R1'
      end
      it 'is the right height' do
        @result[0][:height].should == [19,19,18,18]
      end
      it 'is the right soil temperature' do
        @result[0][:soil_temperature].should == 9.5
      end
      it 'is the right time' do
        @result[0][:seconds].should == 0
      end
      it 'is the right chamber' do
        @result[0][:chamber].should == "1"
      end
      it 'is the right vial' do
        @result[0][:vial].should == '385'
      end
    end

    describe 'the second row' do
      it 'is G1' do
        @result[1][:treatment].should == 'T1'
      end
      it 'is lid Y' do
        @result[1][:lid].should == 'Y'
      end
      it 'is rep 1' do
        @result[1][:replicate].should == 'R1'
      end
      it 'is the right height' do
        @result[1][:height].should == [19,19,18,18]
      end
      it 'is the right soil temperature' do
        @result[1][:soil_temperature].should == 9.5
      end
      it 'is the right time' do
        @result[1][:seconds].should == 15.0
      end
      it 'is the right chamber' do
        @result[1][:chamber].should == "1"
      end
      it 'is the right vial' do
        @result[1][:vial].should == '386'
      end
    end
  end
end
