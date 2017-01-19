class Calibrate
  attr_reader :run

  def initialize(my_run)
    @run = my_run
  end

  def calibrate!
    Compound.all.each do |compound|
      curves = run.standard_curves_for(compound)
      next if curves.empty?
      # TODO: need ot figure out why you get curves with no data.
      bad_curves, good_curves = curves.partition {|x| x.all_zero? || x.data.empty? }
      delete!(bad_curves)
      compute!(good_curves)
      standardize!(good_curves, compound)
      run.recompute_fluxes
    end
  end

  private

 def standardize!(curves, compound)
    st = Standardizer.new
    st.standard_curves = curves
    run.measurements_for(compound).each do |measurement|
      st.to_ppm(measurement)
      measurement.save
    end
  end

  def compute!(curves)
    curves.each do |curve|
      curve.compute!
      curve.save
    end
  end

  def delete!(curves)
    curves.each do |curve|
      curve.destroy
    end
  end
end
