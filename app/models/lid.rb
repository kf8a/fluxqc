class Lid < ActiveRecord::Base
  has_many :incubations
end
# == Schema Information
#
# Table name: lids
#
#  id           :integer         not null, primary key
#  surface_area :float
#  name         :string(255)
#  volume       :float
#  height       :float
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

