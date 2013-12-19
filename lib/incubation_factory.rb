# This class creates incubations based on the setup file
class IncubationFactory

  def self.create(run_id, input= {})
    run = Run.find(run_id)
    incubation = run.incubations.where(:treatment => input[:treatment],
                                 :replicate  => input[:replicate],
                                 :sub_plot   => input[:sub_plot],
                                 :chamber    => input[:chamber],
                                 :sampled_at => input[:sampled_at]).first

    if incubation
      ['n2o','co2','ch4'].each do |c|
        compound = Compound.find_by_name(c)
        flux = incubation.flux(c)
        update_measurement(flux, input, compound, run, incubation)
      end
    else
      incubation = Incubation.new
      incubation.run_id             = run_id
      incubation.treatment          = input[:treatment]
      incubation.replicate          = input[:replicate]
      incubation.sub_plot           = input[:sub_plot]
      incubation.chamber            = input[:chamber]
      incubation.soil_temperature   = input[:soil_temperature]
      incubation.avg_height_cm      = input[:height].inject(:+)/input[:height].count
      incubation.lid                = Lid.find_by_name(input[:lid])
      incubation.sampled_at         = input[:input_at]
      ['n2o','co2','ch4'].each do |c|
        compound = Compound.find_by_name(c)
        flux = Flux.new
        flux.compound = compound

        incubation.fluxes << flux

        update_measurement(flux, input, compound, run, incubation)
      end
      incubation.save
    end
    incubation
  end

  def self.update_sample(measurement, run, vial,incubation)
    sample = run.samples.where(:vial => vial).first
    unless sample
      sample = Sample.new(:vial => vial)
      sample.incubation = incubation
      sample.save
      run.samples << sample
    end
    sample.measurements << measurement
    measurement.save
  end

  def self.update_measurement(flux,input, compound, run, incubation)
    vial = input[:vial]
    measurement = Measurement.new(:seconds => input[:seconds],
                                  :compound => compound,
                                  :vial=>vial)
    flux.measurements << measurement
    update_sample(measurement, run, vial,incubation)
  end
end
