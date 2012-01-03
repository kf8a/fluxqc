class Lid < ActiveRecord::Base
  has_many :incubations
end
# == Schema Information
#
# Table name: lids
#
#  id           :integer         not null, primary key
#  name         :string(1)
#  volume       :float
#  height       :float
#  surface_area :float
#

