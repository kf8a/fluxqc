# Represents a standard curve
class StandardCurve < ActiveRecord::Base
  belongs_to :run
  belongs_to :compound
  has_many :standards
  has_many :check_standards

  def data
    standards.collect {|s| {:id=>s.id, :key=> s.area, :value=> s.ppm, :deleted => s.excluded}}
  end

  def data=(standard_hash=[])
    standard_hash.each do |d|
      standard = standards.find(d[:id])
      standard.excluded = d[:deleted]
      standard.save
    end
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
    h[:ymax] = ymax
    h[:ymin] = ymin
    h[:fit_line] = fit_line
    h
  end

  # convenience methods to make the calculations easier
  def ymax
    compound.ymax if compound
  end

  def ymin
    0
  end
end
