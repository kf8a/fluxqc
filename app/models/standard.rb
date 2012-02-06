# class to hold the parameters for a standard equation
#
class Standard < Measurement
  belongs_to :compound
  belongs_to :sample

  def data
    run.samples.collect do |s|

    end
    measurements.collect do |measurement|
      {id:measurement.id, key:measurement.seconds, value:measurement.ppm, area:measurement.area, deleted:measurement.excluded}
    end
  end

  def compute
    # asks the run for it's standards for a compound
    # extracts the concentration from the name
    # computes a straight line fit for the concentration to areas
    # stores the parameters and r2
    f       = Fitter.new(self)
    result  = f.linear_fit

    slope       = result[:slope]
    multiplier  = result[:multiplier]
    r2          = result[:r2]
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
#  type          :string(255)
#  excluded      :boolean
#  starting_time :datetime
#  ending_time   :datetime
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

