class Measurement < ActiveRecord::Base
  belongs_to :flux

  # return the millivolts readings that are associatated with this measurement
  # i don't know if they should be stored with the object or somewhere else and
  # just keep the start stop times in this object.
  def mv

  end
end
# == Schema Information
#
# Table name: measurements
#
#  id            :integer         not null, primary key
#  flux_id       :integer
#  vial          :string(255)
#  seconds       :float
#  ppm           :float
#  area          :float
#  excluded      :boolean
#  starting_time :datetime
#  ending_time   :datetime
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

