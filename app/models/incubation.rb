class Incubation < ActiveRecord::Base
  has_many :fluxes,  :dependent => :destroy
  belongs_to :run
  belongs_to :lid

  NaN = (0.0/0.0)

  def flux(compound)
    fluxes.send(compound)[0]
  end

  def headspace
    return NaN unless lid
    
    if 'Z' == lid.name
      # compute gas bucket volume 
      # divide by 1000 to convert from cm^3 to liters
      return (Math::PI * (((26 + 0.094697)/2)**2) * (avg_height_cm - 1))/1000 # one cm from the top of the bucket to the mark
    else
      begin
        avg_height_cm = 19.5 unless avg_height_cm
        ((avg_height_cm-(lid.height-1)) * lid.surface_area)/1000 + lid.volume
      rescue NoMethodError
        return NaN
      end
    end
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
    fluxes.first.measurements
  end
end
# == Schema Information
#
# Table name: incubations
#
#  id               :integer         not null, primary key
#  name             :string(25)
#  run_id           :integer
#  soil_temperature :float
#  treatment        :string(255)
#  replicate        :string(255)
#  lid_id           :integer
#  chamber          :string(255)
#  avg_height_cm    :float
#

