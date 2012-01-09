class Sample < ActiveRecord::Base
  has_many :measurements
  belongs_to :run
end
# == Schema Information
#
# Table name: samples
#
#  id           :integer         not null, primary key
#  vial         :string(255)
#  run_id       :integer
#  sampled_date :datetime
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

