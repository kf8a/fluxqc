class Incubation < ActiveRecord::Base
  has_many :fluxes
  belongs_to :run
  belongs_to :lid

  def flux(compound)
    fluxes.send(compound)[0]
  end

  def headspace

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
