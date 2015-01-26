require 'csv'
require File.expand_path("../../../lib/fitter.rb",__FILE__)

# This file represents a flux, that is a series of measuremnemnts of the
# same gas over time. The linear regression slope of the
# meeasurements is the computeed flux.
# It uses the fitter class to do it's work.
class Flux < ActiveRecord::Base
  belongs_to :incubation
  belongs_to :compound
  has_many   :measurements,  :dependent => :destroy

  attr_reader :flux, :muliplier, :data

  before_save do
    incubation.try(:touch)
    incubation.try(:run).try(:touch)
  end

  def self.co2
    includes(:measurements => :compound).where('compounds.name' => 'co2')
  end

  def self.n2o
    includes(:measurements => :compound).where('compounds.name' => 'n2o')
  end

  def self.ch4
    includes(:measurements => :compound).where('compounds.name' => 'ch4')
  end

  def compound
    measurements.first.compound
  end

  def run
    incubation.run
  end

  # Collect the measurements associate with this flux into a hash
  # for display as jason
  def data
    measurements.collect do |measurement|
      {
        id:measurement.id, key:measurement.seconds,
        value:measurement.ppm, area:measurement.area, deleted:measurement.excluded, 
        std_curve: measurement.standard_curves
      }
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
    self.value = compute_flux
  end

  def compute_flux
    f = Fitter.new(self)
    begin
      value = f.fit
      if value.try(:nan?) 
        nil
      else
        value
      end
    rescue 
      nil
    end
  end

  # reduced flux based on 3 points instead of 4
  # I save the data so I can't just create an object
  # def reduced_flux
  #   reduced = Flux.new
  #   reduced.data = self.data.sort {|a,b| a[:key] <=> b[:key]}
  #   reduced.data.pop
  #   f = Fitter.new(reduced)
  #   v = f.fit
  #   v.nan? ? nil : v
  # end

  def multiplier
    f = Fitter.new(self)
    f.multiplier
  end

  def fit_line
    f = Fitter.new(self)
    begin
      line = f.linear_fit

      if line[:slope].nan? 
        line[:slope] = nil
      end

      if line[:offset].nan? 
        line[:offset] = nil
      end
      if line[:r2].nan? 
        line[:r2] = nil
      end
      line
    rescue
      nil
    end
  end

  def as_json(options= {})
    h = super(options)
    h[:data] = data
    h[:compound] = compound
    h[:expected_slope] = compound.name == 'ch4' ? 'negative' : 'positive'
    h[:ymax] = ymax
    h[:ymin] = ymin
    f = fit_line
    if f.try(:nan?)
      h[:fit_line] = nil
    else
      h[:fit_line] = f
    end
    m = multiplier
    if m.try(:nan?)
      h[:multiplier] = nil
    else
      h[:multiplier] = m
    end
    f = flux
    if f.try(:nan?)
      h[:flux] = nil
    else
      h[:flux] = f
    end
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

  def company
    incubation.company
  end

  # CSV streaming support
  def self.csv_header
    CSV::Row.new([:id, :run_id, :run_name, :sampled_on, :study, :treatment, 
                 :replicate, :compund, :flux], 
                 ['id','run id', 'series', 'sampled_on', 'study', 'treatment', 
                   'replicate', 'compound', 'flux'], true)
  end

  def to_csv_row
    CSV::Row.new([:id, :run_id, :run_name, :sampled_on, :study, :treatment, 
                 :replicate, :compound, :flux],
                 [incubation.id, run.id, run.name, run.sampled_on, 
                   run.study,
                   incubation.treatment, incubation.replicate, 
                   compound.name,
                   value])
  end

  def self.find_in_batches(study, &block)
    #find_each will batch the results instead of getting all in one go
    joins(incubation: :run).where('study = ?', study).order('sampled_at').
      find_each(batch_size: 1000) do |flux|
      yield flux 
    end
  end

end

# == Schema Information
#
# Table name: fluxes
#
#  id            :integer          not null, primary key
#  incubation_id :integer
#  value         :float
#  compound_id   :integer
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  fluxes_incubation_id  (incubation_id)
#
