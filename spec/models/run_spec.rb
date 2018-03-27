require 'rails_helper'

describe Run do

  let(:run) {Run.create}

  it { is_expected.to have_many :incubations}
  it { is_expected.to have_many :samples}
  it { is_expected.to have_many :standard_curves}

  it 'reports the total number of fluxes' do
    expect(run.total_fluxes).to eq 0
  end

  it 'recomputes the fluxes' do
    run.recompute_fluxes # just to run through it
    # TODO figure out what the assertion is here
  end

  it 'attaches the standards' do
    expect(run.respond_to?("attach_standards_to_samples")).to be_truthy
  end

  it 'returns the standard curves for a compound' do
    compound = Compound.new
    curve = FactoryBot.build :standard_curve, compound: compound, column: 0
    run.standard_curves << curve
    expect(run.standard_curves_for(compound)).to eq [curve]
  end

  it 'returns the right column standard curve for a compound' do
    compound = Compound.new
    curve0 = FactoryBot.build :standard_curve, compound: compound, column: 0
    curve1 = FactoryBot.build :standard_curve, compound: compound, column: 1
    run.standard_curves = [curve0, curve1]
    expect(run.standard_curves_for(compound, 1)).to eq [curve1]
  end

  it 'returns the right standard curves for a compound when there are multiple curves' do
    compound = Compound.new
    curve0 = FactoryBot.build :standard_curve, compound: compound, column: 0
    curve1 = FactoryBot.build :standard_curve, compound: compound, column: 0
    FactoryBot.build :standard_curve, compound: compound, column: 1
    run.standard_curves = [curve0, curve1]
    expect(run.standard_curves_for(compound, 0)).to eq [curve0, curve1]
  end

  it 'returns the measurements for a compound' do
    compound = Compound.new
    lid = Lid.new
    measurement = FactoryBot.build :measurement, compound: compound, area: 100
    incubation  = FactoryBot.build :incubation, lid: lid
    flux        = FactoryBot.build :flux, compound: compound
    flux.measurements = [measurement]
    incubation.fluxes = [flux]
    run.incubations = [incubation]
    expect(run.measurements_for(compound)).to eq [measurement]
  end

  describe 'handling the workflow' do
    describe 'a new run' do
      it 'starts as uploaded' do
        expect(run.uploaded?).to eq true
      end

      it 'can be accepted' do
        expect(run.can_accept?).to eq true
      end

      it 'reports possible events' do
        expect(run.current_state.events.keys).to include(:accept)
      end
    end

    describe 'an accepted run' do
      before(:each) do
        run.accept!
      end
      it 'can be approved' do
        expect(run.can_approve?).to eq true
      end

      it 'can be rejected' do
        expect(run.can_reject?).to eq true
      end
    end

    describe 'an approved run' do
      before(:each) do
        run.accept!
        run.approve!
      end

      it 'can be published' do
        expect(run.can_publish?).to eq true
      end
      it 'can be rejected' do
        expect(run.can_reject?).to eq true
      end
      it 'can be unapproved' do
        expect(run.can_unapprove?).to eq true
      end
    end

    describe 'a published run' do
      before(:each) do
        run.accept!
        run.approve!
        run.publish!
      end

      it 'can be unpublished' do
        expect(run.can_unpublish?).to eq true
      end
      it 'has released set to true' do
        expect(run.released).to eq true
      end
      it 'sets released to false when recalled' do
        run.unpublish!
        expect(run.released).to eq false
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
#  approved       :boolean          default("false")
#  group_id       :integer
#  study          :string(25)
#  released       :boolean          default("false")
#  workflow_state :string(255)
#  setup_file     :string(255)
#  data_file      :string(255)
#  company_id     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  data_files     :json
#
