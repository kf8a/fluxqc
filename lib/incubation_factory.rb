class IncubationFactory

  def self.create(sample = {})
    incubation = Incubation.new
    incubation.plot = sample[:plot]
    incubation
  end
end
