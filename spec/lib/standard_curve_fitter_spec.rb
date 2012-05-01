#require File.expand_path("../../../lib/standard.rb",__FILE__)
require 'spec_helper'

describe StandardCurve do

  let (:standard) {StandardCurve.new}

  it 'takes an array of samples (standards)'
  it 'computes a standard curve for each compound' do
    compound  = Compound.new
    compound.stub('name').and_return('co2')
    measurement =  Measurement.new
    measurement.compound = compound
    sample = Sample.new
    sample.measurements << measurement
    standard.samples = [sample]
    standard.standardize
  end
  it 'has a standardize function to recompute the standard' do
    standard.respond_to?('standardize').should be_true
  end
  it 'has a ppm function to return ppm given an area' do
    standard.respond_to?('ppm').should be_true
  end
end