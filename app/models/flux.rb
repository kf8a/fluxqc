require File.expand_path("../../../lib/fitter.rb",__FILE__)

class Flux < ActiveRecord::Base
  belongs_to :incubation
  belongs_to :compound
  has_many   :measurements,  :dependent => :destroy

  attr_reader :flux, :muliplier, :data

  scope :co2, joins(:compound).where('compounds.name' => 'co2')
  scope :n2o, joins(:compound).where('compounds.name' => 'n2o') 
  scope :ch4, joins(:compound).where('compounds.name' => 'ch4')

  def data
    p measurements
    measurements.collect do |measurement|
      {id:measurement.id, key:measurement.seconds, value:measurement.ppm, deleted:measurement.excluded}
    end
  end

  def data=(measurement_hash=[])
    measurement_hash.each do |d|
      measurement = measurements.find(d[:id])
      measurement.seconds = d[:key]
      measurement.ppm = d[:value]
      measurement.excluded = d[:deleted]
      measurements << measurement
    end
  end

  def flux
    f = Fitter.new
    f.flux = self
    f.fit
  end

  def multiplier
    f = Fitter.new
    f.flux = self
    f.multiplier
  end

  def fit_line
    f = Fitter.new
    f.data = data
    f.linear_fit
  end

  def as_json(options= {})
    h = super(options)
    h[:data] = data
    h[:ymax] = ymax
    h[:ymin] = ymin
    h[:fit_line] = fit_line
    h[:multiplier] = multiplier
    h[:flux] = flux
    h
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
    incubation.lid.try(:surface_area)
  end

  def mol_weight
    compound.mol_weight
  end
end
