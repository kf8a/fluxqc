# This file represents a flux, that is a series of measuremnemnts of the ssame gas over time. The linear regression slope of the
# meeasurements is the computeed flux. It uses the fitter class to do it's work.
#
require File.expand_path("../../../lib/fitter.rb",__FILE__)

class Flux < ActiveRecord::Base
  belongs_to :incubation
  has_many   :measurements,  :dependent => :destroy

  attr_reader :flux, :muliplier, :data

  scope :co2, includes(:measurements => :compound).where('compounds.name' => 'co2')
  scope :n2o, includes(:measurements => :compound).where('compounds.name' => 'n2o') 
  scope :ch4, includes(:measurements => :compound).where('compounds.name' => 'ch4')

  def compound
    measurements.first.compound
  end

  # Collect the measurements associate with this flux into a hash for display as jason
  def data
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
      measurement.save
    end
    measurements.reload   #TODO I'm missing something here
    flux
  end

  def flux
    f = Fitter.new(self)
    v = f.fit
    v = nil if v.nan?
    self.value = v
  end

  def multiplier
    f = Fitter.new(self)
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
    h[:compound] = compound
    h[:expected_slope] = compound.name == 'ch4' ? 'negative' : 'positive'
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
# == Schema Information
#
# Table name: fluxes
#
#  id            :integer         not null, primary key
#  incubation_id :integer
#  value         :float
#  compound_id   :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

