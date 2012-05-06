# Represents a standard curve
class StandardCurve < ActiveRecord::Base
  belongs_to :run
  belongs_to :compound
  has_many :standards

  def data
    standards.collect {|s| {:id=>s.id, :key=> s.area, :value=> s.ppm, :deleted => s.excluded}}
  end
end
