# An incubation is the period during which the chamber is closed
# The gas accumulating in the chamber during the incubation
# is used to compute the flux of the gas escaping
# into the atmosphere
#
# Incubations are part of run and are specific to a particular plot
class Incubation < ActiveRecord::Base
  has_many :fluxes,  :dependent => :destroy
  # has_many :measurements, -> { order :vial }
  has_many :samples
  belongs_to :run
  belongs_to :lid

  accepts_nested_attributes_for :samples

  def flux(compound)
    fluxes.send(compound)[0]
  end

  def headspace
    return Float::NAN unless lid

    case lid.name
    when 'Z'
      z_lid_headspace
    when 'Y'
      y_lid_headspace
    when 'X'
      x_lid_headspace
    else
      lter_lid_headspace
    end
  end

  def lter_lid_headspace
    begin
      ((avg_height_cm-(lid.height-1)) * lid.surface_area)/1000 + lid.volume
    rescue NoMethodError
      Float::NAN
    end
  end

  # plastic bucket
  # compute gas bucket volume
  # divide by 1000 to convert from cm^3 to liters
  #
  # There is one cm from the top of the bucket to the mark
  def z_lid_headspace
    (Math::PI * (((26 + 0.094697)/2)**2) * (avg_height_cm - 1))/1000
  end

  # metal buckets
  # Pi*14.1^2*(H-0.2cm)   H is typically around 17-19cm  
  # It should be around 10.8L if they install the chambers correctly.  
  # This accounts for the clamped lid after they measure H.  
  # The 0.2 accounts for the decrease in ht due to the lid groove.
  def y_lid_headspace
    (Math::PI * 14.1**2 * (avg_height_cm - 0.2)/1000)
  end

  # cimmyt buckets
  # Pi * 25/2 * H
  def x_lid_headspace
    (Math::PI * (25/2.0)**2 * avg_height_cm)/1000
  end

  def co2
    flux('co2')
  end

  def n2o
    flux('n2o')
  end

  def ch4
    flux('ch4')
  end

  def vials
    fluxes.first.measurements.collect {|measurement| measurement.sample.vial }
  end

  def update_samples
    self.samples << fluxes.first.measurements.collect(&:sample)
  end

  def seconds
    fluxes.first.measurements.map(&:seconds)
  end

  def company
    run.company
  end

  def recompute_fluxes
    fluxes.each do |f|
      f.flux
      f.save
    end
  end

  def measurements_for(compound)
    fluxes.select {|x| x.compound == compound}.collect {|x| x.measurements }.flatten
  end
end

# == Schema Information
#
# Table name: incubations
#
#  id               :integer          not null, primary key
#  name             :string(25)
#  run_id           :integer
#  soil_temperature :float
#  treatment        :string(255)
#  replicate        :string(255)
#  lid_id           :integer
#  chamber          :string(255)
#  avg_height_cm    :float
#  sampled_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  sub_plot         :string(255)
#
# Indexes
#
#  incubation_run_id  (run_id)
#
