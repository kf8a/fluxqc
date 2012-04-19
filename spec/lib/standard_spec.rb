require File.expand_path("../../../lib/standard.rb",__FILE__)
describe Standard do

  let (:standard) {Standard.new([])}

  it 'takes an array of samples (standards)'
  it 'has a standardize function to recompute the standard' do
    standard.respond_to?('standardize').should be_true
  end
  it 'has a ppm function to return ppm given an area' do
    standard.respond_to?('ppm').should be_true
  end
end
