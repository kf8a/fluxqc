#require File.expand_path("../../../lib/standard.rb",__FILE__)
require 'spec_helper'

describe StandardCurveFitter do

  let (:standard_curve_fitter) {StandardCurveFitter.new}

  it 'computes a standard curve for each compound' do
    compound  = Compound.new
    compound.stub('name').and_return('co2')
    measurement =  Measurement.new
    measurement.compound = compound
    sample = Sample.new
    sample.measurements << measurement
    standard_curve_fitter.samples = [sample]
    standard_curve_fitter.standardize
  end

  it 'has a standardize function to compute the standard curve' do
    compound = Compound.new
    compound.stub('name').and_return('co2')
    standard_curve = StandardCurve.new
    standard1 = Standard.new
    standard1.compound = compound
    standard2 = Standard.new
    standard2.compound = compound
    standard_curve.standards << [standard1, standard2]
    standard_curve_fitter.standardize
    standard_curve.slope.should == 3
    standard_curve.intercept.should == 1
  end

  it 'should work with more than one standard curve' do
  end

  it 'has a ppm function to return ppm given an area' do
    standard_curve_fitter.respond_to?('ppm').should be_true
  end

end
