# Represents a vial of gas collected.
# The vial is collected at a particular time after the start of the incubation
# and will be analysed for one or more compounds
# the data from several samples are used to compute the flux
class Sample < ActiveRecord::Base
  has_many :measurements, dependent: :destroy
  belongs_to :run
  belongs_to :incubation
  has_many :calibrations
  has_many :standard_curves, through: :calibrations

  # attr_accessor :seconds 

  scope :with_compound, lambda {|compound| where(:compound => compound) }

  # TODO need to do this before save
  before_save :make_uuid, :if => Proc.new {|object| object.uuid.nil? }

  def data(compound_name)
    # measurements.by_compound(compound_name)
    measurements.find {|x| x.compound.name == compound_name }
  end

  def seconds=(s)
    measurements.each do |m|
      m.seconds = s
      m.save
    end
  end

  def seconds
    measurements.first.try(:seconds)
  end

  def get_dependent_fluxes_for(compound)
    fluxes = measurements.by_compound(compound).collect {|measurement| measurement.flux }
    fluxes.uniq
  end

  private
  def make_uuid
    if self.uuid.nil?
      self.uuid = UUID.new.generate
    end
  end
end

# == Schema Information
#
# Table name: samples
#
#  id            :integer          not null, primary key
#  vial          :string(255)
#  run_id        :integer
#  sampled_at    :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  uuid          :string(255)
#  incubation_id :integer
#
# Indexes
#
#  index_samples_on_incubation_id  (incubation_id)
#  samples_run_id_vial_key         (run_id,vial) UNIQUE
#
