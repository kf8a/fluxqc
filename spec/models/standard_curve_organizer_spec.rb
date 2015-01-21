# == Schema Information
#
# Table name: standard_curve_organizers
#
#  id         :integer          not null, primary key
#  run_id     :integer
#  curves     :text
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe StandardCurveOrganizer do
  it {should belong_to :run}

  it 'should return the standard curves of the run' do
    pending "Need to rethink if I need the organizer"
    run = FactoryGirl.create :run
    run.standard_curves << StandardCurve.new
    run.standard_curve_organizer = StandardCurveOrganizer.new
    expect(run.standard_curve_organizer.standard_curves).to eq []
  end
end
