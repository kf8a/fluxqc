require File.expand_path("../../../lib/fitter.rb",__FILE__)

class Flux < ActiveRecord::Base
  belongs_to :incubation
  belongs_to :compound
  has_many   :measurements

  scope :co2, joins(:compound).where('compounds.name' => 'co2')
  scope :n2o, joins(:compound).where('compounds.name' => 'n2o') 
  scope :ch4, joins(:compound).where('compounds.name' => 'ch4')

  def data
    measurements.collect do |measurement|
      {key:measurement.seconds, value:measurement.ppm, deleted:measurement.excluded}
    end
  end

  def multiplier
    f = Fitter.new
    f.flux = self
    f.multiplier
  end

  # convenience methods to make the calculations easier
  def ymax
    compound.ymax
  end

  def ymin
    0
  end

  def headspace
    incubation.headspace
  end

  def surface_area
    incubation.lid.surface_area
  end

  def mol_weight
    compound.mol_weight
  end
end
