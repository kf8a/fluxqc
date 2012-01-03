class IncubationFactory

  def self.create(sample = {})
    incubation = Incubation.find_by_treatment_replicate_chamber_sampled_at(sample[:treatment], sample[:replicate], sample[:chamber], sample[:sample_at])

    incubation = incubation || Incubation.new
    incubation.treatment          = sample[:treatment]
    incubation.replicate          = sample[:replicate]
    incubation.chamber            = sample[:chamber]
    incubation.soil_temperature   = sample[:soil_temperature]
    incubation.average_height_cm  = sample[:height].inject(:+)/sample[:height].count
    incubation.lid                = Lid.find_by_name(sample[:lid])
    incubation.sampled_at         = sample[:sample_at]
    incubation
  end
end
