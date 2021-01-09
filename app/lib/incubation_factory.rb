# frozen_string_literal: true

# This class creates incubations based on the setup file
class IncubationFactory
  COMPOUND_NAMES = %w[n2o co2 ch4].freeze

  def initialize(run_id)
    @run = Run.find(run_id)

    @compounds = Compound.where(name: COMPOUND_NAMES).all
  end

  # def self.create(run_id, input = {})
  def create(input = {})
    incubation = @run.incubations.where(treatment: input[:treatment],
                                        replicate: input[:replicate],
                                        sub_plot: input[:sub_plot],
                                        chamber: input[:chamber]).first
                                        # sampled_at: input[:sampled_at]).first
    if incubation
      @compounds.each do |compound|
        flux = Flux.where(incubation_id: incubation.id).first
        # flux = incubation.flux(compound)
        update_measurement(flux, input, compound, incubation)
      end
    else
      incubation = Incubation.new
      incubation.run_id             = @run.id
      incubation.treatment          = input[:treatment]
      incubation.replicate          = input[:replicate]
      incubation.sub_plot           = input[:sub_plot]
      incubation.chamber            = input[:chamber]
      incubation.soil_temperature   = input[:soil_temperature]
      incubation.avg_height_cm      = input[:height].inject(:+) / input[:height].count
      incubation.lid                = Lid.find_by_name(input[:lid])
      incubation.sampled_at         = input[:input_at]
      @compounds.each do |compound|
        flux = Flux.new
        flux.compound = compound

        incubation.fluxes << flux

        update_measurement(flux, input, compound, incubation)
      end
      incubation.save
    end
    incubation
  end

  def update_sample(measurement, vial, incubation)
    sample = get_sample(vial, incubation)
    sample.measurements << measurement
    measurement.save
  end

  def get_sample(vial, incubation)
    sample = @run.samples.where(vial: vial).first
    return sample if sample

    sample = Sample.new(vial: vial)
    sample.incubation = incubation
    @run.samples << sample
    sample.save
    sample
  end

  def update_measurement(flux, input, compound, incubation)
    vial = input[:vial]
    measurement = Measurement.new(seconds: input[:seconds],
                                  compound: compound,
                                  vial: vial)
    flux.measurements << measurement
    update_sample(measurement, vial, incubation)
  end
end
