# The Fitter class does a linear regression on the flux object
# it gets used by fluxes to compute the flux value.
# Fluxes pass themselvs to the Fitter
class Fitter
  attr_accessor :data

  def initialize(flux=nil)
    if flux
      @flux = flux
      @data = @flux.data
    end
  end

  def fit
    result = linear_fit

    result[:slope] * multiplier
  end

  def multiplier
    headspace     = @flux.headspace.to_f
    surface_area  = @flux.surface_area.to_f
    mol_weight    = @flux.mol_weight.to_f

    headspace/surface_area * 100 * 1440 /22.4 * mol_weight
  end

  def linear_fit
    sum_x = sum_y = sum_xy = sum_xx = sum_yy = count = 0

    raise 'no data to compute linear fit' unless data
    return ({:slope=>Float::NAN, :offset=>Float::NAN, :r2=>Float::NAN}) if data.length < 2

    data.each do |datum|
      next if datum[:deleted]
      next unless datum[:key]
      next unless datum[:value]
      x = datum[:key]
      y = datum[:value]
      sum_x  += x
      sum_y  += y
      sum_xx += x*x
      sum_yy += y*y
      sum_xy += x*y
      count  += 1
    end

    return ({:slope=>Float::NAN, :offset=>Float::NAN, :r2=>Float::NAN}) if count == 0

    m = (count * sum_xy - sum_x * sum_y)/(count * sum_xx - sum_x * sum_x)
    b = (sum_y/count) - (m * sum_x)/count

    mean_y = sum_y/count
    sst = sse = 0

    correlation = (count * sum_xy - sum_x * sum_y)/Math.sqrt((count * sum_xx - sum_x * sum_x)*(count * sum_yy - sum_y * sum_y))
    r2 = correlation * correlation

    {:slope=>m, :offset=>b, :r2=>r2}
  end
end
