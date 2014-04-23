require "csv"
# Measurement represents a measurement that is made on a sample
# For example in a particular sample vial a measurement might
# be made for CO2 and another measurement for N2O.
class Measurement < ActiveRecord::Base
  belongs_to :sample
  belongs_to :flux
  belongs_to :compound

  def self.by_compound(name)
    joins(:compound).where(:compounds => {:name => name}).readonly(false)
  end
  # return the millivolts readings that are associatated with this measurement
  # i don't know if they should be stored with the object or somewhere else and
  # just keep the start stop times in this object.
  def mv

  end

  #This is used to compute the distance for the drift correction
  def position
    acquired_at.to_s
  end

  def run
    sample.run
  end

  def standard_curves
    [previous_standard_curve, next_standard_curve].compact
  end

  # CSV streaming support
  def self.csv_header
    CSV::Row.new([:id, :sampled_on, :study, :treatment, :replicate, :lid, :minutes, :ppm, :avg_height, :name], 
                 ['id','sampled_on', 'study', 'treatment', 'replicate', 'lid', 'minutes','ppm', 'avg_height_cm', 'name'], true)
  end

  def to_csv_row
    CSV::Row.new([:id, :sampled_on, :study, :treatment, :replicate, :lid, :minutes, :ppm, :avg_height, :name], 
                 [flux.incubation.id, sample.run.sampled_on, sample.run.study,
                   flux.incubation.treatment, flux.incubation.replicate, flux.incubation.lid.try(:name),
                   seconds, ppm, flux.incubation.avg_height_cm, compound.name])
  end

  # def self.find_in_batches(filters, batch_size, &block)
  def self.find_in_batches(&block)
    #find_each will batch the results instead of getting all in one go
    joins(flux: {incubation: :run}).where('company_id =2 and excluded is false').find_each(batch_size: 1000) do |measurement|
      yield measurement 
    end
  end

  private
  def previous_standard_curve
    run.standard_curves.where(column: column).where('acquired_at < ?', acquired_at).order('acquired_at desc').first
  end

  def next_standard_curve
    run.standard_curves.where(column: column).where('acquired_at > ?', acquired_at).order('acquired_at').first
  end
end

# == Schema Information
#
# Table name: measurements
#
#  id               :integer          not null, primary key
#  response         :float
#  excluded         :boolean          default(FALSE)
#  flux_id          :integer
#  seconds          :integer
#  ppm              :float
#  comment          :string(255)
#  vial             :integer
#  run_id           :integer
#  compound_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  area             :float
#  type             :string(255)
#  starting_time    :datetime
#  ending_time      :datetime
#  sample_id        :integer
#  column           :integer
#  acquired_at      :datetime
#  original_seconds :integer
#
# Indexes
#
#  index_measurements_on_compound_id  (compound_id)
#  index_measurements_on_sample_id    (sample_id)
#  sample_flux_id                     (flux_id)
#  sample_run_id                      (run_id)
#
