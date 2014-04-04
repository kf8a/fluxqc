class Calibration < ActiveRecord::Base
  belongs_to :standard_curve
  belongs_to :measurement
end
