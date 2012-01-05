require 'spec_helper'

describe Run do

  let(:run) {Run.new}

  it {should have_many :incubations}

  it 'reports the total number of fluxes' do
    run.total_fluxes.should == 0
  end

  describe 'handling the workflow' do
    describe 'a new run' do
      it 'starts as uploaded' do
        run.uploaded?.should be_true
      end

      it 'can be accepted' do
        run.can_accept?.should be_true
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
        run.can_approve?.should be_true
      end

      it 'can be rejected' do
        run.can_reject?.should be_true
      end
    end

    describe 'an approved run' do
      before(:each) do
        run.accept!
        run.approve!
      end

      it 'can be published' do
        run.can_publish?.should  be_true
      end
      it 'can be rejected' do
        run.can_reject?.should be_true
      end
      it 'can be unapproved' do
        run.can_unapprove?.should be_true
      end
    end

    describe 'a published run' do
      before(:each) do
        run.accept!
        run.approve!
        run.publish!
      end

      it 'can be unpublished' do
        run.can_unpublish?.should be_true
      end
      it 'has released set to true' do
        run.released.should be_true
      end
      it 'sets released to false when recalled' do
        run.unpublish!
        run.released.should be_false
      end
    end
  end
end
