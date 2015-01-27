class Calibrate
  attr_reader :run

  def initialize(my_run)
    @run = my_run
  end

  def calibrate!
    Compound.all.each do |compound|
      curves = run.standard_curves_for(compound)
      next if curves.empty?
      curves.each do |curve|
        curve.compute!
        curve.save
      end
      st = Standardizer.new
      st.standard_curves = curves
      run.measurements_for(compound).each do |measurement|
        st.to_ppm(measurement)
        measurement.save
      end
      run.recompute_fluxes
    end
  end
end
