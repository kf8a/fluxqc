require 'rails_helper'

describe SetupParser do

  describe 'parsing an lter csv setup file' do
    before do
      file = File.expand_path('../../fixtures/setup_test.csv', __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = SetupParser.parse(file)
    end

    it 'returns an array of sample hashes' do
      expect(@result.class).to eq Array
    end

    it 'has the right run title' do
      expect(@result[0][:run_name]).to eq 'LTER 2011 Series 10'
    end

    describe 'first row' do
      it 'has the right sample date' do
        expect(@result[0][:sample_date]).to eq Time.parse('2011-8-19 12:00:00')
      end
      it 'has the right treatment' do
        expect(@result[0][:treatment]).to eq 'T6'
      end
      it 'has the right replicate' do
        expect(@result[0][:replicate]).to eq 'R1'
      end
      it 'has the right chamber' do
        expect(@result[0][:chamber]).to eq '1'
      end
      it 'has the right vial' do
        expect(@result[0][:vial]).to eq '1'
      end
      it 'has the right lid' do
        expect(@result[0][:lid]).to eq 'C'
      end
      it 'has the right height' do
        expect(@result[0][:height]).to eq [18, 19.5, 19, 20.5]
      end
      it 'has the right soil_temperature' do
        expect(@result[0][:soil_temperature]).to eq 18.5
      end
      it 'has the right seconds' do
        expect(@result[0][:seconds]).to eq 0
      end
    end

    it 'returns the right data for a string treatment second row' do
      expect(@result[1][:treatment]).to eq 'T6'
    end

    describe 'other row' do
      it 'has the right sample date' do
        expect(@result[5][:sample_date]).to eq Time.parse('2011-8-19 12:00:00')
      end
      it 'has the right treatment' do
        expect(@result[5][:treatment]).to eq 'T2'
      end
      it 'has the right replicate' do
        expect(@result[5][:replicate]).to eq 'R1'
      end
      it 'has the right chamber' do
        expect(@result[5][:chamber]).to eq '1'
      end
      it 'has the right vial' do
        expect(@result[5][:vial]).to eq '7'
      end
      it 'has the right lid' do
        expect(@result[5][:lid]).to eq 'D'
      end
      it 'has the right height' do
        expect(@result[5][:height]).to eq [19.5, 19.0, 19.0, 19.0]
      end
      it 'has the right soil_temperature' do
        expect(@result[5][:soil_temperature]).to eq 19
      end
      it 'has the right seconds' do
        expect(@result[5][:seconds]).to eq 40
      end
    end
  end

  describe 'parsing a GLBRC file' do

    before do
      file = File.expand_path("../../fixtures/glbrc_setup.csv", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = SetupParser.parse(file)
    end

    it 'has the right title' do
        expect(@result[0][:run_name]).to eq 'GLBRC 2011 Series 1'
    end

    it 'has the right sample date' do
      expect(@result[0][:sample_date]).to eq Time.parse('2011-4-7 12:00:00')
    end

    describe 'the first row' do
      it 'is G1' do
        expect(@result[0][:treatment]).to eq 'G1'
      end
      it 'is lid Y' do
        expect(@result[0][:lid]).to eq 'Y'
      end
      it 'is rep 1' do
        expect(@result[0][:replicate]).to eq 'R1'
      end
      it 'is the right height' do
        expect(@result[0][:height]).to eq [18,17.5,18,17]
      end
      it 'is the right soil temperature' do
        expect(@result[0][:soil_temperature]).to eq 8
      end
      it 'is the right time' do
        expect(@result[0][:seconds]).to eq 0
      end
      it 'is the right chamber' do
        expect(@result[0][:chamber]).to eq "1"
      end
      it 'is the right vial' do
        expect(@result[0][:vial]).to eq '1'
      end
    end

    describe 'the second row' do
      it 'is G1' do
        expect(@result[1][:treatment]).to eq 'G1'
      end
      it 'is lid Y' do
        expect(@result[1][:lid]).to eq 'Y'
      end
      it 'is rep 1' do
        expect(@result[1][:replicate]).to eq 'R1'
      end
      it 'is the right height' do
        expect(@result[1][:height]).to eq [18,17.5,18,17]
      end
      it 'is the right soil temperature' do
        expect(@result[1][:soil_temperature]).to eq 8
      end
      it 'is the right time' do
        expect(@result[1][:seconds]).to eq 18
      end
      it 'is the right chamber' do
        expect(@result[1][:chamber]).to eq "1"
      end
      it 'is the right vial' do
        expect(@result[1][:vial]).to eq '2'
      end
    end
  end

  describe 'parsing a GLBRC scaleup setup file' do
    before do
      file = File.expand_path("../../fixtures/lux_setup.csv", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = SetupParser.parse(file)
    end

    it 'has the right title' do
      expect(@result[0][:run_name]).to eq 'GLBRC 2011 Series 1 Lux Arbor'
    end

    it 'has the right sample date' do
      expect(@result[0][:sample_date]).to eq Time.parse('2011-4-7 12:00:00')
    end

    describe 'the first row' do
      it 'is L1' do
        expect(@result[0][:treatment]).to eq 'L1'
      end
      it 'is lid Y' do
        expect(@result[0][:lid]).to eq 'Y'
      end
      it 'is rep 1' do
        expect(@result[0][:replicate]).to eq 'R1'
      end
      it 'is the right height' do
        expect(@result[0][:height]).to eq [19, 19, 18, 18]
      end
      it 'is the right soil temperature' do
        expect(@result[0][:soil_temperature]).to eq 9.5
      end
      it 'is the right time' do
        expect(@result[0][:seconds]).to eq 0
      end
      it 'is the right chamber' do
        expect(@result[0][:chamber]).to eq '1'
      end
      it 'is the right vial' do
        expect(@result[0][:vial]).to eq '385'
      end
    end

    describe 'the second row' do
      it 'is L1' do
        expect(@result[1][:treatment]).to eq 'L1'
      end
      it 'is lid Y' do
        expect(@result[1][:lid]).to eq 'Y'
      end
      it 'is rep 1' do
        expect(@result[1][:replicate]).to eq 'R1'
      end
      it 'is the right height' do
        expect(@result[1][:height]).to eq [19,19,18,18]
      end
      it 'is the right soil temperature' do
        expect(@result[1][:soil_temperature]).to eq 9.5
      end
      it 'is the right time' do
        expect(@result[1][:seconds]).to eq 15.0
      end
      it 'is the right chamber' do
        expect(@result[1][:chamber]).to eq "1"
      end
      it 'is the right vial' do
        expect(@result[1][:vial]).to eq '386'
      end
    end
  end

  describe 'loading and excel file' do
    before do
      file = File.expand_path('../../fixtures/winter-gas-setup.xls', __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = SetupParser.parse(file)
    end

    describe 'the first row' do
      before do
        @row = @result[0]
      end
      it 'is T6' do
        expect(@row[:treatment]).to eq 'T6'
      end
      it 'is R1' do
        expect(@row[:replicate]).to eq 'R1'
      end
      it 'has the right vial' do
        expect(@row[:vial]).to eq '1'
      end
    end
    describe 'the 81s row' do
      before do
        @row = @result[81]
      end
      it 'is T6' do
        expect(@row[:treatment]).to eq 'T3'
      end
      it 'is R1' do
        expect(@row[:replicate]).to eq 'R3'
      end
      it 'has 20 seconds' do
        expect(@row[:seconds]).to eq 20
      end
      it 'has the right chamber' do
        expect(@row[:chamber]).to eq '1'
      end
      it 'has the rigth lid' do
        expect(@row[:lid]).to eq 'Y'
      end
      it 'has the right vial' do
        expect(@row[:vial]).to eq '82'
      end
    end
  end

  describe 'loading an excel file with format 4' do
    before do
      file = File.expand_path('../../fixtures/glbrc-setup-format.xls', __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = SetupParser.parse(file)
    end

    describe 'the first row' do
      before do
        @row = @result[0]
      end
      it 'is the right treatment'
      it 'is the right rep' do
        expect(@row[:replicate]).to eq 'R1'
      end
      it 'has the right seconds' do
        expect(@row[:seconds]).to eq 0
      end
      it 'has the right chamber' do
        expect(@row[:chamber]).to eq '1'
      end
      it 'has the rigth lid' do
        expect(@row[:lid]).to eq 'Y'
      end
      it 'has the right vial' do
        expect(@row[:vial]).to eq "1"
      end
    end
  end

  describe 'loading an excel file with format 6' do
    before do
      file = File.expand_path("../../fixtures/lter-gas-2019.xls", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = SetupParser.parse(file)
    end

    describe 'the first row' do
      before do
        @row = @result[0]
      end
      it 'has the right sample date' do
        expect(@row[:sample_date].to_date).to eq Date.parse('2019-5-15')
      end
      it 'is the right treatment' do
        expect(@row[:treatment]).to eq 'T6'
      end
      it 'is the right rep' do
        expect(@row[:replicate]).to eq 'R1'
      end
      it 'has the right subplot' do
        expect(@row[:sub_plot]).to eq nil
      end
      it 'has the right seconds' do
        expect(@row[:seconds]).to eq 0
      end
      it 'has the right chamber' do
        expect(@row[:chamber]).to eq '1'
      end
      it 'has the rigth lid' do
        expect(@row[:lid]).to eq 'Y'
      end
      it 'has the right vial' do
        expect(@row[:vial]).to eq "1"
      end
      it 'has the right comment' do
        expect(@row[:comments]).to eq "HOBO 8:22-9:04"
      end
    end
    describe 'the second row' do
      before do
        @row = @result[1]
      end
      it 'is the right treatment' do
        expect(@row[:treatment]).to eq 'T7'
      end
      it 'is the right rep' do
        expect(@row[:replicate]).to eq 'R3'
      end
      it 'has the right vial' do
        expect(@row[:vial]).to eq "119"
      end
      it 'has the right subplot' do
        expect(@row[:sub_plot]).to eq '12.3F'
      end
    end
    describe 'the third row' do
      before do
        @row = @result[2]
      end
      it 'is the right treatment' do
        expect(@row[:treatment]).to eq 'T3'
      end
      it 'is the right rep' do
        expect(@row[:replicate]).to eq 'R3'
      end
      it 'has the right vial' do
        expect(@row[:vial]).to eq "269"
      end
      it 'has the right subplot' do
        expect(@row[:sub_plot]).to eq 'strip'
      end
    end
  end

  describe 'loading another excel file with format 6' do
    before do
      file = File.expand_path("../../fixtures/lter-gas-2019-series-1.xlsx", __FILE__)
      expect(File.exists?(file)).to be_truthy
      @result = SetupParser.parse(file)
    end

    describe 'the first row' do
      before do
        @row = @result[0]
      end
      it 'has the right sample date' do
        expect(@row[:sample_date].to_date).to eq Date.parse('2019-4-11')
      end
      it 'is the right treatment' do
        expect(@row[:treatment]).to eq 'T6'
      end
      it 'is the right rep' do
        expect(@row[:replicate]).to eq 'R1'
      end
      it 'has the right subplot' do
        expect(@row[:sub_plot]).to eq nil
      end
      it 'has the right seconds' do
        expect(@row[:seconds]).to eq 0
      end
      it 'has the right chamber' do
        expect(@row[:chamber]).to eq '1'
      end
      it 'has the rigth lid' do
        expect(@row[:lid]).to eq 'Y'
      end
      it 'has the right vial' do
        expect(@row[:vial]).to eq "1"
      end
      it 'has the right comment' do
        expect(@row[:comments]).to eq 'Start Time: 8:24'
      end
    end
  end
end
