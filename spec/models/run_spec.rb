require 'spec_helper'

describe Run do

  let(:run) {Run.create}

  it {should have_many :incubations}
  it {should have_many :samples}
  it {should have_many :standard_curves}

  it 'reports the total number of fluxes' do
    run.total_fluxes.should == 0
  end

  it 'recomputes the fluxes' do
    run.respond_to?('recompute_fluxes').should be_true
    run.recompute_fluxes # just to run through it
    # TODO figure out what the assertion is here
  end

  it 'attaches the standards' do
    run.respond_to?("attach_standards_to_samples").should be_true
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

# == Schema Information
#
# Table name: runs
#
#  id             :integer          not null, primary key
#  run_on         :date
#  sampled_on     :date
#  name           :string(50)
#  comment        :text
#  approved       :boolean          default(FALSE)
#  group_id       :integer
#  study          :string(25)
#  released       :boolean          default(FALSE)
#  workflow_state :string(255)
#  setup_file     :string(255)
#  data_file      :string(255)
#  company_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#
