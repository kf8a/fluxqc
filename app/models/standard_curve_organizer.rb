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

class StandardCurveOrganizer < ActiveRecord::Base
  belongs_to :run
  has_many :standard_curves, dependent: :destroy

end
