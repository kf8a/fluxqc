# == Schema Information
#
# Table name: calibrations
#
#  id                :integer          not null, primary key
#  standard_curve_id :integer
#  sample_id         :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class Calibration < ActiveRecord::Base
  belongs_to :standard_curve
  belongs_to :sample
end
