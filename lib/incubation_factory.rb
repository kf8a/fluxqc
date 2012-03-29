class IncubationFactory

  def self.create(run_id, input= {})
    run = Run.find(run_id)
    incubation = run.incubations.where(:treatment => input[:treatment],
                                 :replicate  => input[:replicate],
                                 :chamber    => input[:chamber],
                                 :sampled_at => input[:sampled_at]).first

    if incubation
      ['n2o','co2','ch4'].each do |c|
        compound = Compound.find_by_name(c)
        flux = incubation.flux(c)
        update_measurement(flux, input, compound, run)
      end
    else
      incubation = Incubation.new
      incubation.run_id             = run_id
      incubation.treatment          = input[:treatment]
      incubation.replicate          = input[:replicate]
      incubation.chamber            = input[:chamber]
      incubation.soil_temperature   = input[:soil_temperature]
      incubation.avg_height_cm  = input[:height].inject(:+)/input[:height].count
      incubation.lid                = Lid.find_by_name(input[:lid])
      incubation.sampled_at         = input[:input_at]
      ['n2o','co2','ch4'].each do |c|
        compound = Compound.find_by_name(c)
        flux = Flux.new
        incubation.fluxes << flux

        update_measurement(flux, input, compound, run)
      end
      incubation.save
    end
    incubation
  end

  def self.update_sample(measurement, run, vial)
    sample = run.samples.where(:vial => vial).first
    unless sample
      sample = Sample.new(:vial => vial)
      sample.save
      run.samples << sample
    end
    sample.measurements << measurement
    measurement.save
  end

  def self.update_measurement(flux,input, compound, run)
    vial = input[:vial]
    measurement = Measurement.new(:seconds => input[:seconds], :compound => compound, :vial=>vial)
    flux.measurements << measurement
    update_sample(measurement, run, vial)
  end
end
