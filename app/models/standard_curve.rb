# Represents a standard curve
class StandardCurve < ActiveRecord::Base
  belongs_to :run
  belongs_to :compound
  has_many :standards, dependent: :destroy
  has_many :check_standards, dependent: :destroy
  has_many :calibrations
  has_many :samples, through: :calibrations

  # before_save do
  #   run.try(:touch) unless run.try(:new_record?)
  # end

  def data
    standards.collect { |s| { id: s.id, key: s.area, value: s.ppm, name: s.vial, deleted: s.excluded } }
  end

  def data=(standard_hash = [])
    standard_hash ||= []
    standard_hash.each do |d|
      standard = standards.find(d[:id])
      standard.excluded = d[:deleted]
      standard.save
    end
  end

  def fit_line
    f = Fitter.new
    f.data = data
    begin
      f.linear_fit
    rescue
      {}
    end
  end

  def get_dependent_fluxes
    fluxes = samples.collect { |sample| sample.get_dependent_fluxes_for(compound) }
    fluxes.uniq
  end

  def as_json(options = {})
    h = super(options)
    h[:data] = data
    h[:compound] = compound
    h[:ymax] = ymax
    h[:ymin] = ymin
    h[:fit_line] = fit_line
    # h[:fluxes] = get_dependent_fluxes
    h
  end

  # convenience methods to make the calculations easier
  def ymax
    compound.ymax if compound
  end

  def ymin
    0
  end

  def empty?

  end

  def all_zero?
    data.collect { |x| x[:key] }.compact.uniq.size == 1
  end

  def empty?
    data.empty?
  end

  def compute!
    result = fit_line
    self.slope = result.fetch(:slope, Float::NAN)
    self.intercept = result.fetch(:offset, Float::NAN)
    [slope, intercept]
  end

  # This is used to compute the distance for the drift correction
  def position
    acquired_at.to_s
  end
end
