class Measurement < ActiveRecord::Base
  belongs_to :sample
  belongs_to :flux

  def self.by_compound(name)
    includes(:flux=>:compound).where('compounds.name' => name)
  end

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
#  seconds       :float
#  ppm           :float
#  area          :float
#  excluded      :boolean
#  starting_time :datetime
#  ending_time   :datetime
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  sample_id     :integer
#

