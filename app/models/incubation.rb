class Incubation < ActiveRecord::Base
  has_many :fluxes

  def flux(compound)
    fluxes.send(compound)[0]
  end
end
