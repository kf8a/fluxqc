require 'spec_helper'

describe Run do

  let(:run) {Run.new}

  it {should have_many :incubations}

  it 'starts as uploaded' do
    run.uploaded?.should be_true
  end

  it 'can be accepted' do
    run.accept!.should be_true
  end
  
end
