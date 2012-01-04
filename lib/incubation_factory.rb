class IncubationFactory

  def self.create(sample = {})
    incubation = Incubation.where(:treatment => sample[:treatment],
                                 :replicate  => sample[:replicate],
                                 :chamber    => sample[:chamber],
                                 :sampled_at=> sample[:sampled_at]).first

    if incubation
      ['n2o','co2','ch4'].each do |compound|
        flux = incubation.flux(compound)
        measurement = Measurement.new(:vial => sample[:vial], 
                                      :seconds => sample[:seconds])
        flux.measurements << measurement
      end
    else
      incubation = Incubation.new
      incubation.treatment          = sample[:treatment]
      incubation.replicate          = sample[:replicate]
      incubation.chamber            = sample[:chamber]
      incubation.soil_temperature   = sample[:soil_temperature]
      incubation.average_height_cm  = sample[:height].inject(:+)/sample[:height].count
      incubation.lid                = Lid.find_by_name(sample[:lid])
      incubation.sampled_at         = sample[:sample_at]
      ['n2o','co2','ch4'].each do |compound|
        compound = Compound.find_by_name(compound)
        flux = Flux.new(:compound => compound)
        measurement = Measurement.new(:vial => sample[:vial], 
                                      :seconds => sample[:seconds])
        flux.measurements << measurement
        incubation.fluxes << flux
      end
    end
    incubation
  end
end
