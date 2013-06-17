# This class takes one or more standard curves
# and then computes the ppms of a measurement
# based on the current standard curve and the
# drift between standard curves

class Standardizer
  attr_accessor :standard_curves

  def to_ppm(measurement)
    return unless standard_curves
    if standard_curves.size == 1
      measurement.ppm = single_standard_ppm(measurement)
    else
      measurement.ppm = average_standard_ppm(measurement)
    end
  end

  private
  def single_standard_ppm(measurement)
    standard_curves[0].intercept + standard_curves[0].slope * measurement.area
  end

  def average_standard_ppm(measurement)
    intercept = standard_curves.inject(0) {|sum, n| sum + n.intercept } / standard_curves.size
    slope     = standard_curves.inject(0) {|sum, n| sum + n.slope } / standard_curves.size
    measurement.ppm = intercept + slope * measurement.area
  end

  def drift_corrected_ppm(measurement)
    current_position = measurement.vial
  end
end
