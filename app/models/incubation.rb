class Incubation < ActiveRecord::Base
  has_many :fluxes
  belongs_to :run

  def flux(compound)
    fluxes.send(compound)[0]
  end

  def co2
    flux('co2').id
  end

  def n2o
    flux('n2o').id
  end

  def ch4
    flux('ch4').id
  end
end
