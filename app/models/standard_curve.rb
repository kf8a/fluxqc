# Represents a standard measurement
# This is exactly the same as a measurement except that we know
# both the area and the ppm.
# Measurements and Standards have the same fields.
class Standard < ActiveRecord::Base
  belongs_to :run
  belongs_to :compound
  has_many :measurements
end
