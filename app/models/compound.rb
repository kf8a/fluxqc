class Compound < ActiveRecord::Base
  has_many :measurements
  has_many :standards

  validates_uniqueness_of :name
end
# == Schema Information
#
# Table name: compounds
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  ymin       :float
#  ymax       :float
#  unit       :string(255)
#  mol_weight :float
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

