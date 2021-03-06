# frozen_string_literal: true

# This class takes one or more standard curves
# and then computes the ppms of a measurement
# based on the current standard curve and the
# drift between standard curves
class Standardizer
  attr_accessor :standard_curves

  def standardize(_run)
  end

  def to_ppm(measurement)
    return unless standard_curves
    return unless measurement.area

    measurement.ppm = if standard_curves.size == 1
                        single_standard_ppm(measurement)
                      else
                        average_standard_ppm(measurement)
                      end
  end

  def to_ppm_with_drift_correction(measurement)
    return unless standard_curves
    return unless measurement.area

    measurement.ppm = drift_corrected_ppm(measurement)
  end

  private

  def single_standard_ppm(measurement)
    standard_curves[0].intercept + standard_curves[0].slope * measurement.area
  end

  def average_standard_ppm(measurement)
    return unless standard_curves.size > 0

    intercept = standard_curves.inject(0) { |sum, n| sum + n.intercept } / standard_curves.size
    slope     = standard_curves.inject(0) { |sum, n| sum + n.slope } / standard_curves.size
    measurement.ppm = intercept + slope * measurement.area
  end

  def slope_data
    fitter_data('slope')
  end

  def intercept_data
    fitter_data('intercept')
  end

  def fitter_data(param)
    [
      { key: standard_curves[0].position,
        value: standard_curves[0].send(param) },
      { key: standard_curves[1].position,
        value: standard_curves[1].send(param) }
    ]
  end

  def drift_corrected_ppm(measurement)
    # compute fit eq for slope correction
    fitter = Fitter.new
    fitter.data = slope_data
    slope_params = fitter.linear_fit

    # compute fit eq for offset correction
    fitter.data = intercept_data
    intercept_params = fitter.linear_fit

    slope = slope_params[:offset] + slope_params[:slope] * measurement.position
    intercept = intercept_params[:offset] + intercept_params[:slope] * measurement.position

    measurement.ppm = intercept + slope * measurement.area
  end
end
