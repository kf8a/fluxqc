# Represents a standard curve
class StandardCurve < ActiveRecord::Base
  belongs_to :run
  belongs_to :compound
  has_many :standards, dependent: :destroy
  has_many :check_standards, dependent: :destroy

  def data
    standards.collect {|s| {:id=>s.id, :key=> s.area, :value=> s.ppm, :name => s.vial, :deleted => s.excluded}}
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

  def compute!
    result = fit_line
    self.slope      = result[:slope]
    self.intercept  = result[:offset]
  end

  #This is used to compute the distance for the drift correction
  def position
    acquired_at.to_s
  end
end

# == Schema Information
#
# Table name: standard_curves
#
#  id          :integer          not null, primary key
#  run_id      :integer
#  compound_id :integer
#  slope       :float
#  intercept   :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

