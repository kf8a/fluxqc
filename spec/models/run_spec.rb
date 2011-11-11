require 'spec_helper'

describe Run do

  let(:run) {Run.new}

  it {should have_many :incubations}

  it 'reports the total number of fluxes' do
    run.total_fluxes.should == 0
  end
  
  it 'reports the number of approved fluxes' do
    run.approved_fluxes.should == 0
  end

  describe 'the workflow' do
    describe 'a new run' do
      it 'starts as uploaded' do
        run.uploaded?.should be_true
      end

      it 'can be accepted' do
        run.accept!.should be_true
      end

      it 'reports possible events' do
        run.current_state.events.keys.should include(:accept)
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
end
