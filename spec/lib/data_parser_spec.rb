require File.expand_path("../../../lib/data_parser.rb",__FILE__)

describe DataParser do

  describe 'parsing a results file' do
    before do
      file = File.expand_path("../../fixtures/result.txt", __FILE__)
      File.exists?(file).should be_true
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
        @row[:column].should == 1
      end
    end
    describe 'row 17' do
      before do
        @row = @result[17]
      end
      it 'sets the right column' do
        @row[:column].should == 0
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
      File.exists?(file).should be_true
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      @result.size.should == 364
    end

  end

  describe 'parsing an old results file' do
    before do
      file = File.expand_path("../../fixtures/lter2007-forestfert1.csv", __FILE__)
      File.exists?(file).should be_true
      @result = DataParser.new.parse(file)
    end

    it 'finds the correct number of samples' do
      @result.size.should == 82
    end

    describe 'row 14' do
      before do
        @row = @result[14]
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

  # TODO do I need to deal with encoding issues..
  # describe 'parsing a macro generated file' do
  #   before do
  #     file = File.expand_path("../../fixtures/2011_results.csv", __FILE__)
  #     File.exists?(file).should be_true
  #     @result = DataParser.parse(file)
  #   end

  #   it 'finds the correct number of samples' do
  #     @result.size.should == 364
  #   end
  # end
end
