# The Compound class represents the analyte that is of interest
# It is currently N2O, CO2, and CH4.
class Compound < ActiveRecord::Base
  has_many :measurements
  has_many :standards

  validates_uniqueness_of :name
end

# == Schema Information
#
# Table name: compounds
#
#  id         :integer          not null, primary key
#  name       :string(10)
#  mol_weight :float
#  unit       :string(255)
#  ymax       :float
#  ymin       :float
#
