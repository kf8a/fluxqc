class IncubationFactory

  def self.create(sample = {})
    incubation = Incubation.where(:treatment => sample[:treatment],
                                 :replicate  => sample[:replicate],
                                 :chamber    => sample[:chamber],
                                 :sampled_at=> sample[:sampled_at]).first

    unless incubation
      incubation = Incubation.new
      incubation.treatment          = sample[:treatment]
      incubation.replicate          = sample[:replicate]
      incubation.chamber            = sample[:chamber]
      incubation.soil_temperature   = sample[:soil_temperature]
      incubation.average_height_cm  = sample[:height].inject(:+)/sample[:height].count
      incubation.lid                = Lid.find_by_name(sample[:lid])
      incubation.sampled_at         = sample[:sample_at]
    end
    incubation
  end
end
