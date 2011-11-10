class Flux < ActiveRecord::Base
  belongs_to :incubation
  belongs_to :compound
  has_many   :measurements

  scope :co2, joins(:compound).where('compounds.name' => 'co2')
  scope :n2o, joins(:compound).where('compounds.name' => 'n2o') 
  scope :ch4, joins(:compound).where('compounds.name' => 'ch4')

  def data
    measurements.collect do |measurement|
      {key:measurement.seconds, value:measurement.ppm}
    end
  end

  # convenience methods to make the caluclation easier
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
