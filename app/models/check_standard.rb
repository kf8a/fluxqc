class CheckStandard < ActiveRecord::Base
  belongs_to :standard_curve
  attr_accessible :vial, :ppm, :area, :excluded, :compound_id
end

# == Schema Information
#
# Table name: check_standards
#
#  id                :integer          not null, primary key
#  standard_curve_id :integer
#  compound_id       :integer
#  vial              :string(255)
#  ppm               :float
#  area              :float
#  excluded          :boolean          default(TRUE)
#  starting_time     :datetime
#  ending_time       :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

