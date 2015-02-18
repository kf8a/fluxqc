require File.expand_path("../../../lib/data_parser.rb",__FILE__)

describe DataParser do

  describe 'parsing a results file' do
    before do
      file = File.expand_path("../../fixtures/result.txt", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      expect(@result.size).to eq 304
    end

    describe 'row 18' do
      before do
        @row = @result[18]
      end
      it 'sets the right column' do
        expect(@row[:n2o][:column]).to eq 1
      end
    end
    describe 'row 17' do
      before do
        @row = @result[17]
      end
      it 'sets the right column' do
        expect(@row[:n2o][:column]).to eq 0
      end
      it 'finds the right vial' do
        expect(@row[:vial]).to eq '4'
      end
      it 'finds the right ch4 value' do
        expect(@row[:ch4][:area]).to eq 27.806454
      end
      it 'finds the right co2 value' do
        expect(@row[:co2][:area]).to eq 117673.960937
      end
      it 'finds the right n2o value' do
        expect(@row[:n2o][:area]).to eq 392.561584
      end
    end

    describe 'row 7' do
      before do
        @row = @result[7]
      end
      it 'finds the right vial' do
        expect(@row[:vial]).to eq '15b'
      end
      it 'finds the right ch4 value' do
        expect(@row[:ch4][:area]).to eq 23.846161
      end
      it 'finds the right co2 value' do
        expect(@row[:co2][:area]).to eq 55572.550781
      end
      it 'finds the right n2o value' do
        expect(@row[:n2o][:area]).to eq 590.933777
      end
    end
  end

  describe 'parsing a reprocessed results file' do

    before do
      file = File.expand_path("../../fixtures/results_2.txt", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      expect(@result.size).to eq 364
    end

  end

  describe 'parsing another chemstation result file' do
    before do
      file = File.expand_path("../../fixtures/2012_result.txt", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = DataParser.new.parse(file)
    end
    describe 'row 17' do
      before do
        @row = @result[17]
      end
      it 'finds the right sample time' do
        expect(@row[:acquired_at]).to eq DateTime.new(2012, 4, 12, 16, 0, 34)
      end
      it 'finds the right vial' do
        expect(@row[:vial]).to eq '4'
      end
      it 'finds the right ch4 area' do 
        expect(@row[:ch4][:area]).to eq 21.521156
      end
      it 'finds the right co2 area' do
        expect(@row[:co2][:area]).to eq 235565.078125
      end
      it 'finds the right n2o area' do
        expect(@row[:n2o][:area]).to eq 388.917969
      end
    end
  end

  describe 'parsing a 2010 file with standards' do
    before do
      file = File.expand_path("../../fixtures//glbrc-2010.csv", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = DataParser.new.parse(file)
    end

    it 'should have 4 rows' do
      expect(@result.size).to eq 4
    end
    describe 'row 3' do
      before do 
        @row = @result[2]
      end

      it 'finds the right vial' do
        expect(@row[:vial]).to eq '3'
      end

      it 'finds the right ppm' do
        expect(@row[:n2o][:ppm]).to eq 0.300734331
      end
    end
  end

  describe 'parsing a second chemstation file' do
    before do
      file = File.expand_path("../../fixtures//LTER20130520S4.CSV", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      expect(@result.size).to eq 295
    end

    describe 'row 17' do
      before do
        @row = @result[17]
      end

      it 'is not null' do
        expect(@row).to_not be_nil
      end

      it 'finds the right vial' do
        expect(@row[:vial]).to eq "11"
      end
    end

  end

  describe 'parsing another chemstation result file' do
    before do
      file = File.expand_path("../../fixtures/LTER20130702S7.CSV", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      expect(@result.size).to eq 299
    end

    describe 'row 17' do
      before do
        @row = @result[17]
      end

      it 'finds the right vial' do
        expect(@row[:vial]).to eq "11"
      end
      it 'finds the right ch4 area' do 
        expect(@row[:ch4][:area]).to eq 17.119198
      end
      it 'finds the right co2 area' do
        expect(@row[:co2][:area]).to eq 88616.09375
      end
      it 'finds the right n2o area' do
        expect(@row[:n2o][:area]).to eq 421.389252
      end

    end
  end

  describe 'parsing an old results file' do
    before do
      file = File.expand_path("../../fixtures/lter2007-forestfert1.csv", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      expect(@result.size).to eq 72
    end

    describe 'row 4' do
      before do
        @row = @result[4]
      end
      it 'finds the right vial' do
        expect(@row[:vial]).to eq '141'
      end
      it 'finds the right ch4 value' do
        expect(@row[:ch4][:ppm]).to eq 3.1506
      end
      it 'finds the right ch4 area' do 
        expect(@row[:ch4][:area]).to eq 25384.0
      end
      it 'finds the right co2 value' do
        expect(@row[:co2][:ppm]).to eq 736.9668
      end
      it 'finds the right co2 area' do
        expect(@row[:co2][:area]).to eq 1224.0
      end
      it 'finds the right n2o value' do
        expect(@row[:n2o][:ppm]).to eq 0.292976
      end
      it 'finds the right n2o area' do
        expect(@row[:n2o][:area]).to eq 96694.0
      end
    end

  end

  describe 'parsing a CIMMYT result file' do

    before do
      @parser = DataParser.new
    end

    it 'parses the vial correctly' do
      vial = @parser.parse_vial(["12/07/12 6:49:12 PM",29,"07-Dec-12, 18:44:16","F-107-T0","CH4",0.500317,22.6583])
      expect(vial).to eq "F-107-T0"
    end

    it 'parses a shorted vial correctly' do
      vial = @parser.parse_vial(["12/07/12 6:49:12 PM",29,"07-Dec-12, 18:44:16","B107-T0","CH4",0.500317,22.6583])
      expect(vial).to eq "B-107-T0"
    end

    it 'parses a vial with series correctly' do
      vial = @parser.parse_vial(["12/07/12 6:49:12 PM",29,"07-Dec-12, 18:44:16","S13-CIM-B-107-T0","CH4",0.500317,22.6583])
      expect(vial).to eq "S13-CIM-B-107-T0"
    end

    it 'parses the area correctly' do
      row = @parser.chemstation_parse(["12/07/12 6:49:12 PM",29,"07-Dec-12, 18:44:16","S13-CIM-B-107-T0","CH4",0.500317,22.6583, 22.6, "co2",100, 200, 200, "n2o", 4, 40, 40])
      expect(row[:ch4][:area]).to eq 22.6583
      expect(row[:n2o][:area]).to eq 40
      expect(row[:co2][:area]).to eq 200
    end

  end


  describe "time parsing in a cimmit file" do
    before do 
      @parser = DataParser.new
    end
    it "parses time correctly" do
      expect(@parser.parse_time("10-Jan-14 16:42:47")).to eq DateTime.new(2014,1,10,16,42,47)
    end
    it 'parses other format' do
      expect(@parser.parse_time("1/10/2014 16:42:47")).to eq DateTime.new(2014,1,10,16,42,47)
    end
    it 'parses other format' do
      expect(@parser.parse_time("01/10/2014 4:42:47 PM")).to eq DateTime.new(2014,1,10,16,42,47)
    end
    it 'parses other format' do
      expect(@parser.parse_time('04/12/12 3:46:15 PM')).to eq DateTime.new(2012,4,12,15,46,15)
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
