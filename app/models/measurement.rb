class Measurement < ActiveRecord::Base
  belongs_to :flux

  # return the millivolts readings that are associatated with this measurement
  # i don't know if they should be stored with the object or somewhere else and
  # just keep the start stop times in this object.
  def mv

  end
end
