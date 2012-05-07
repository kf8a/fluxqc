# Represents a standard curve
class StandardCurve < ActiveRecord::Base
  belongs_to :run
  belongs_to :compound
  has_many :standards

  def data
    standards.collect {|s| {:id=>s.id, :key=> s.ppm , :value=> s.area, :deleted => s.excluded}}
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
    h
  end

  # convenience methods to make the calculations easier
  def ymax
    compound.ymax
  end

  def ymin
    0
  end
end
