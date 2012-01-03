class Compound < ActiveRecord::Base
  has_many :fluxes
end
# == Schema Information
#
# Table name: compounds
#
#  id         :integer         not null, primary key
#  name       :string(10)
#  mol_weight :float
#  unit       :string(255)
#  ymax       :float
#

