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
#  id          :integer         not null, primary key
#  response    :float
#  excluded    :boolean         default(FALSE)
#  flux_id     :integer
#  seconds     :integer
#  ppm         :float
#  comment     :string(255)
#  vial        :integer
#  run_id      :integer
#  compound_id :integer
#

