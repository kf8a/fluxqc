require 'spec_helper'

describe Run do

  let(:run) {Run.new}

  it {should have_many :incubations}

  describe 'a new run' do
    it 'starts as uploaded' do
      run.uploaded?.should be_true
    end

    it 'can be accepted' do
      run.accept!.should be_true
    end
  end

  describe 'an accepted run' do
    before(:each) do
      run.accept!
    end
    it 'can be approved' do
      run.approve!.should be_true
    end

    it 'can be rejected' do
      run.reject!.should be_true
    end
  end

  describe 'an approved run' do
    before(:each) do
      run.accept!
      run.approve!
    end

    it 'can be published' do
      run.publish!.should  be_true
    end
    it 'can be rejected' do
      run.reject!.should be_true
    end
    it 'can be unapproved' do
      run.unapprove!.should be_true
    end
  end

  describe 'a published run' do
    before(:each) do
      run.accept!
      run.approve!
      run.publish!
    end

    it 'can be rejected' do
      run.reject!.should be_true
    end
    it 'can be recalled' do
      run.recall!.should be_true
    end
  end
  
end
