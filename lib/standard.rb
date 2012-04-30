require File.expand_path('./lib/fitter.rb')
class StandardCurve

  attr_accessor :samples

  def initialize(sample_array=[])
    super()
    samples = sample_array
  end

  # Recomputes the standard curve for all of the compounds in the samples supplied
  def standardize
    compounds = samples.collect do |s|
      s.measurements.collect {|m| m.compound }
    end.flatten.uniq

    @standard_curve = {}
    compounds.each do |c|
      samples.collect do |s|
        s.measurements.by_compound(c.name)
      end
    end
  end

  # Takes measurement object and returns the ppm based on the current standard curve
  def ppm(measurement)

  end
end
