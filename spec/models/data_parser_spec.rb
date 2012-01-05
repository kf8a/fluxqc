require File.expand_path("../../../lib/data_parser.rb",__FILE__)

describe DataParser do

  describe 'parsing a results file' do
    before do
      file = File.expand_path("../../fixtures/result.txt", __FILE__)
      File.exists?(file).should be_true
      @result = DataParser.parse(file)
    end

    it 'finds the correct number of samples' do
      @result.size.should == 305
    end
    
    describe 'row 17' do
      before do
        @row = @result[17]
      end
      it 'finds the right vial' do
        @row[:vial].should == '4'
      end
      it 'finds the right ch4 value' do
        @row[:ch4].should == 27.806454
      end
      it 'finds the right co2 value' do
        @row[:co2].should == 117673.960937
      end
      it 'finds the right n2o value' do
        @row[:n2o].should == 392.561584
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
        @row[:ch4].should == 23.846161 
      end
      it 'finds the right co2 value' do
        @row[:co2].should == 55572.550781
      end
      it 'finds the right n2o value' do
        @row[:n2o].should == 590.933777
      end
    end
  end

end
