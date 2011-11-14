class Fitter
  attr_accessor :data, :flux

  def fit
    @data = flux.data
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

    return([ [], [] ]) if data.length == 0

    data.each do |datum|
      next if datum[:deleted]
      x = datum[:key]
      y = datum[:value]
      sum_x  += x
      sum_y  += y
      sum_xx += x*x
      sum_yy += y*y
      sum_xy += x*y
      count  += 1
    end
    
    return ([[],[]]) if count == 0

    m = (count * sum_xy - sum_x * sum_y)/(count * sum_xx - sum_x * sum_x)
    b = (sum_y/count) - (m * sum_x)/count

    mean_y = sum_y/count
    sst = sse = 0

    correlation = (count * sum_xy - sum_x * sum_y)/Math.sqrt((count * sum_xx - sum_x * sum_x)*(count * sum_yy - sum_y * sum_y))
    r2 = correlation * correlation

    {:slope=>m, :offset=>b, :r2=>r2}
  end
end
