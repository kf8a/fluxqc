# Measurement represents a measurement that is made on a sample
# For example in a particular sample vial a measurement might
# be made for CO2 and another measurement for N2O.
class Measurement < ActiveRecord::Base
  belongs_to :sample
  belongs_to :flux
  belongs_to :compound
  belongs_to :standard_curve

  def self.by_compound(name)
    joins(:compound).where(:compounds => {:name => name}).readonly(false)
  end
  # return the millivolts readings that are associatated with this measurement
  # i don't know if they should be stored with the object or somewhere else and
  # just keep the start stop times in this object.
  def mv

  end

  #This is used to compute the distance for the drift correction
  def position
    acquired_at.to_s
  end
end

# == Schema Information
#
# Table name: measurements
#
#  id            :integer          not null, primary key
#  flux_id       :integer
#  compound_id   :integer
#  sample_id     :integer
#  vial          :string(255)
#  seconds       :float
#  ppm           :float
#  area          :float
#  type          :string(255)
#  excluded      :boolean
#  starting_time :datetime
#  ending_time   :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

