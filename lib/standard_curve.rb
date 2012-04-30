require File.expand_path('./lib/fitter.rb')

# The Standard Curve class is used to compute the standard curve for a run.
# It takes an array of standards and then uses the Fitter class
# to perform the fitting. It then hold on to the equation so that measurements
# can be converted from area to ppm by calling ppm(meaurement.area)
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
