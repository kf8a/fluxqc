class Sample < ActiveRecord::Base
  has_many :measurements
  has_many :standards
  belongs_to :run

  def data(compound_name)
    measurements.by_compound(compound_name)
  end

  def seconds
    measurements.first.seconds
  end
end
# == Schema Information
#
# Table name: samples
#
#  id         :integer         not null, primary key
#  vial       :string(255)
#  run_id     :integer
#  sampled_at :datetime
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

