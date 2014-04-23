# This represent the chamber lids used during the incubation
# Different lids are used for different studies and at different times
# The lid is indicated in the setup of the run
class Lid < ActiveRecord::Base
  has_many :incubations

  validates_uniqueness_of :name
end

# == Schema Information
#
# Table name: lids
#
#  id           :integer          not null, primary key
#  name         :string(1)
#  volume       :float
#  height       :float
#  surface_area :float
#
