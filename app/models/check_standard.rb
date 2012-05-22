class CheckStandard < ActiveRecord::Base
  belongs_to :standard_curve
  attr_accessible :vial, :ppm, :area, :excluded, :compound_id
end
