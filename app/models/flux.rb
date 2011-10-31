class Flux < ActiveRecord::Base
  belongs_to :incubation
  has_many   :measurements

  scope :co2, where(:compound => 'co2')
  scope :n2o, where(:compound => 'n2o')
  scope :ch4, where(:compound => 'ch4')

  def data
    measurements.collect do |measurement|
      {key:measurement.seconds, value:measurement.ppm}
    end
  end
end
