#require 'spec_helper'
require File.expand_path("../../../lib/loader.rb", __FILE__)

describe Loader do
  let(:loader) {Loader.new}
  it 'should have a parse method' do
    loader.respond_to?(:parse).should be_true
  end

  it 'should parse simple files as well'

  it 'should parse a line correctly' do
    input = <<-eos
      08/22/11 10:58:58 AM	1	22-Aug-11, 10:53:22	blkA	CH4	0.437258	16.46376	16.46376	co2	200	0	0	N2O	1.2	0	0	AutoInt	Z:\GLBRC SER9 2011 0817\GLBRC SERIES 9 2011 2011-08-22 10-50-33\BLKA.D
    eos

    loader.parse(input).should eq([{:name => 'blkA', :ch4 => 0.437258, :co2 => 200, :n2o=> 1.2}])
  end

  it 'should parse another line correctly' do
    input = <<-eos
      08/22/11 12:48:10 PM	17	22-Aug-11, 12:42:34	3	CH4	0.397708	31.839516	31.839516	co2	1.498643	54527.238281	54527.238281	N2O	3.612209	424.092468	424.092468	AutoInt	Z:\GLBRC SER9 2011 0817\GLBRC SERIES 9 2011 2011-08-22 10-50-33\3.D
    eos

    loader.parse(input).should eq([{:name=>'3', :ch4=>0.397708, :co2=>1.498643, :n2o=>3.612209}])
  end

  it 'should handle multi line input' do
   input = <<-eos
      08/22/11 12:48:10 PM	17	22-Aug-11, 12:42:34	3	CH4	0.397708	31.839516	31.839516	co2	1.498643	54527.238281	54527.238281	N2O	3.612209	424.092468	424.092468	AutoInt	Z:\GLBRC SER9 2011 0817\GLBRC SERIES 9 2011 2011-08-22 10-50-33\3.D
      08/22/11 10:58:58 AM	1	22-Aug-11, 10:53:22	blkA	CH4	0.437258	16.46376	16.46376	co2	200	0	0	N2O	1.2	0	0	AutoInt	Z:\GLBRC SER9 2011 0817\GLBRC SERIES 9 2011 2011-08-22 10-50-33\BLKA.D
    eos
    output = [ {:name=>'3',    :ch4=>0.397708, :co2=>1.498643, :n2o=>3.612209},
               {:name=>'blkA', :ch4=>0.437258, :co2 => 200,    :n2o=> 1.2} ]
    loader.parse(input).should eq(output)
  end

end
