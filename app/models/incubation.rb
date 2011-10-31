class Incubation < ActiveRecord::Base
  has_many :fluxes
  belongs_to :run

  def flux(compound)
    fluxes.send(compound)[0]
  end
end
