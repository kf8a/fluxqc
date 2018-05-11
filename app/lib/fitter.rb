# The Fitter class does a linear regression on the flux object
# it gets used by fluxes to compute the flux value.
# Fluxes pass themselvs to the Fitter

class FitterError < StandardError
end

class Fitter
  # include Adamantium

  attr_accessor :data
  attr_reader :slope, :offset, :r2, :correlation

  def initialize(flux = nil)
    return unless flux

    @flux = flux
    @data = @flux.data
  end

  def fit
    result = linear_fit

    if result[:slope]
      result[:slope] * multiplier
    end
  end
  # memoize :fit

  def multiplier
    headspace     = @flux.headspace.to_f
    surface_area  = @flux.surface_area.to_f
    mol_weight    = @flux.mol_weight.to_f

    # these conversion factors here are from http://lter.kbs.msu.edu/protocols/23
    # 1440 = 24 * 60
    # 100 = 10000 cm^2/m^2 * 10000 m^2/ha * 1 mg/1000 ug * 1g /1000 ug
    headspace / surface_area * 100 * 1440 / 22.4 * mol_weight
  end
  # memoize :multiplier

  def linear_fit
    sum_x = sum_y = sum_xy = sum_xx = sum_yy = count = 0

    raise FitterError, 'no data to compute linear fit' unless data
    # return ({:slope=>Float::NAN, :offset=>Float::NAN, :r2=>Float::NAN}) if data.length < 2
    raise FitterError, 'can not compute slope with less than 2 data points' if data.length < 2
    # return {} if data.length < 2
    raise FitterError, 'can not compute slope with only 1 x value' if only_one_x_value?(data)
    data.each do |datum|
      next if bad_datum(datum)
      x = datum[:key].to_f
      y = datum[:value].to_f
      sum_x  += x
      sum_y  += y
      sum_xx += x * x
      sum_yy += y * y
      sum_xy += x * y
      count  += 1
    end

    return { slope: Float::NAN, offset: Float::NAN, r2: Float::NAN } if count.zero?
    # return  if count == 0

    @slope = (count * sum_xy - sum_x * sum_y) / (count * sum_xx - sum_x * sum_x)
    @offset = (sum_y / count) - (slope * sum_x) / count

    mean_y = sum_y / count
    sst = sse = 0

    @correlation = (count * sum_xy - sum_x * sum_y) /
                   Math.sqrt((count * sum_xx - sum_x * sum_x) * (count * sum_yy - sum_y * sum_y))
    @r2 = correlation * correlation
    { slope: slope, offset: offset, r2: r2 }
  end

  def bad_datum(datum)
    datum[:deleted] || no_key_value(datum)
  end

  def no_key_value(datum)
    (!datum[:key] || !datum[:value])
  end

  def only_one_x_value?(data)
    x = data.collect { |datum| datum[:key] }
    x.reverse == x
  end
end
