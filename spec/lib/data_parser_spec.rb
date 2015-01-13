require File.expand_path("../../../lib/data_parser.rb",__FILE__)

describe DataParser do

  describe 'parsing a results file' do
    before do
      file = File.expand_path("../../fixtures/result.txt", __FILE__)
      File.exists?(file).should eq true
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      @result.size.should == 304
    end

    describe 'row 18' do
      before do
        @row = @result[18]
      end
      it 'sets the right column' do
        @row[:n2o][:column].should == 1
      end
    end
    describe 'row 17' do
      before do
        @row = @result[17]
      end
      it 'sets the right column' do
        @row[:n2o][:column].should == 0
      end
      it 'finds the right vial' do
        @row[:vial].should == '4'
      end
      it 'finds the right ch4 value' do
        @row[:ch4][:area].should == 27.806454
      end
      it 'finds the right co2 value' do
        @row[:co2][:area].should == 117673.960937
      end
      it 'finds the right n2o value' do
        @row[:n2o][:area].should == 392.561584
      end
    end

    describe 'row 7' do
      before do
        @row = @result[7]
      end
      it 'finds the right vial' do
        @row[:vial].should == '15b'
      end
      it 'finds the right ch4 value' do
        @row[:ch4][:area].should == 23.846161
      end
      it 'finds the right co2 value' do
        @row[:co2][:area].should == 55572.550781
      end
      it 'finds the right n2o value' do
        @row[:n2o][:area].should == 590.933777
      end
    end
  end

  describe 'parsing a reprocessed results file' do

    before do
      file = File.expand_path("../../fixtures/results_2.txt", __FILE__)
      File.exists?(file).should eq true
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      @result.size.should == 364
    end

  end

  describe 'parsing another chemstation result file' do
    before do
      file = File.expand_path("../../fixtures/2012_result.txt", __FILE__)
      File.exists?(file).should eq true
      @result = DataParser.new.parse(file)
    end
    describe 'row 17' do
      before do
        @row = @result[17]
      end
      it 'finds the right sample time' do
        @row[:acquired_at].should  == Time.new(2012, 04, 12, 15, 54, 47)
      end
      it 'finds the right vial' do
        @row[:vial].should == '4'
      end
      it 'finds the right ch4 area' do 
        @row[:ch4][:area].should == 21.521156
      end
      it 'finds the right co2 area' do
        @row[:co2][:area].should == 235565.078125
      end
      it 'finds the right n2o area' do
        @row[:n2o][:area].should == 388.917969
      end
    end
  end

  describe 'parsing a 2010 file with standards' do
    before do
      file = File.expand_path("../../fixtures//glbrc-2010.csv", __FILE__)
      File.exists?(file).should eq true
      @result = DataParser.new.parse(file)
    end

    it 'should have 4 rows' do
      @result.size.should == 4
    end
    describe 'row 3' do
      before do 
        @row = @result[2]
      end

      it 'finds the right vial' do
        @row[:vial].should == '3'
      end

      it 'finds the right ppm' do
        @row[:n2o][:ppm].should == 0.300734331
      end
    end
  end

  describe 'parsing a second chemstation file' do
    before do
      file = File.expand_path("../../fixtures//LTER20130520S4.CSV", __FILE__)
      File.exists?(file).should eq true
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      @result.size.should == 295
    end

    describe 'row 17' do
      before do
        @row = @result[17]
      end

      it 'should not be null' do
        @row.should_not be_nil
      end

      it 'finds the right vial' do
        @row[:vial].should == "11"
      end
    end

  end

  describe 'parsing another chemstation result file' do
    before do
      file = File.expand_path("../../fixtures/LTER20130702S7.CSV", __FILE__)
      File.exists?(file).should eq true
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      @result.size.should == 299
    end

    describe 'row 17' do
      before do
        @row = @result[17]
      end

      it 'finds the right vial' do
        @row[:vial].should == "11"
      end
      it 'finds the right ch4 area' do 
        @row[:ch4][:area].should == 17.119198
      end
      it 'finds the right co2 area' do
        @row[:co2][:area].should == 88616.09375
      end
      it 'finds the right n2o area' do
        @row[:n2o][:area].should == 421.389252
      end

    end
  end

  describe 'parsing an old results file' do
    before do
      file = File.expand_path("../../fixtures/lter2007-forestfert1.csv", __FILE__)
      File.exists?(file).should eq true
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      @result.size.should == 72
    end

    describe 'row 4' do
      before do
        @row = @result[4]
      end
      it 'finds the right vial' do
        @row[:vial].should == '141'
      end
      it 'finds the right ch4 value' do
        @row[:ch4][:ppm].should == 3.1506
      end
      it 'finds the right ch4 area' do 
        @row[:ch4][:area].should == 25384.0
      end
      it 'finds the right co2 value' do
        @row[:co2][:ppm].should == 736.9668
      end
      it 'finds the right co2 area' do
        @row[:co2][:area].should == 1224.0
      end
      it 'finds the right n2o value' do
        @row[:n2o][:ppm].should == 0.292976
      end
      it 'finds the right n2o area' do
        @row[:n2o][:area].should == 96694.0
      end
    end

  end

  describe 'parsing a CIMMYT result file' do

    before do
      @parser = DataParser.new
    end

    it 'parses the vial correctly' do
      vial = @parser.parse_vial(["12/07/12 6:49:12 PM",29,"07-Dec-12, 18:44:16","F-107-T0","CH4",0.500317,22.6583])
      vial.should == "F-107-T0"
    end

    it 'parses a shorted vial correctly' do
      vial = @parser.parse_vial(["12/07/12 6:49:12 PM",29,"07-Dec-12, 18:44:16","B107-T0","CH4",0.500317,22.6583])
      vial.should == "B-107-T0"
    end

    it 'parses a vial with series correctly' do
      vial = @parser.parse_vial(["12/07/12 6:49:12 PM",29,"07-Dec-12, 18:44:16","S13-CIM-B-107-T0","CH4",0.500317,22.6583])
      vial.should == "S13-CIM-B-107-T0"
    end

    it 'parses the area correctly' do
      row = @parser.chemstation_parse(["12/07/12 6:49:12 PM",29,"07-Dec-12, 18:44:16","S13-CIM-B-107-T0","CH4",0.500317,22.6583, 22.6, "co2",100, 200, 200, "n2o", 4, 40, 40])
      row[:ch4][:area].should == 22.6583
      row[:n2o][:area].should == 40
      row[:co2][:area].should == 200
    end

  end

  # TODO do I need to deal with encoding issues..
  # describe 'parsing a macro generated file' do
  #   before do
  #     file = File.expand_path("../../fixtures/2011_results.csv", __FILE__)
  #     File.exists?(file).should eq true
  #     @result = DataParser.parse(file)
  #   end

  #   it 'finds the correct number of samples' do
  #     @result.size.should == 364
  #   end
  # end
end
