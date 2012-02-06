require 'spec_helper'

describe Standard do
  it {should belong_to :sample}
  it {should belong_to :compound}

  let(:standard) {Standard.new}
  describe 'standardizing' do
    it 'computes a standard equation for the run'
    it 'computes ppms using the standard equation'
  end
end
