# frozen_string_literal: true

# The Run class is the root class of the system.
# It holds references to incubations and standards.
# A run represents one sampling time. It consists of all of the samples
# taken during a sampling event on a particular study
class Run < ActiveRecord::Base
  belongs_to :company
  has_many :incubations, -> { order 'treatment, replicate' }, dependent: :destroy
  has_many :samples, dependent: :destroy
  has_many :standard_curves, dependent: :destroy
  # has_many :data_files, dependent: :destroy

  mount_uploader :setup_file, SetupUploader
  # mount_uploader :data_file, DataUploader
  mount_uploaders :data_files, DataUploader

  accepts_nested_attributes_for :incubations, :samples

  scope :by_state, ->(state) { where(workflow_state: state) }

  # after_save :recompute_fluxes

  include Workflow
  workflow do
    state :uploaded do
      event :accept,  transitions_to: :accepted
      event :park,    transitions_to: :parked
    end
    state :accepted do
      event :approve, transitions_to: :approved
      event :reject,  transitions_to: :rejected
    end
    state :approved do
      event :publish, transitions_to: :published
      event :reject,  transitions_to: :rejected
      event :unapprove, transitions_to: :accepted
    end
    state :published do
      event :unpublish, transitions_to: :approved
    end
    state :rejected do
      event :unreject, transitions_to: :uploaded
    end
    state :parked do
      event :unpark, transitions_to: :uploaded
    end
    on_transition do |_from, _to, _triggering_event, *_event_args|
      touch
    end
  end

  def total_fluxes
    incubations.count * 3
  end

  def publish
    self.released = true
  end

  def unpublish
    self.released = false
  end

  def upload
    self.uploaded = true
  end

  def recompute_fluxes
    incubations.each(&:recompute_fluxes)
  end

  def measurements_for(compound)
    incubations.collect { |incubation| incubation.measurements_for(compound) }.flatten
  end

  def standard_curves_for(compound, column = 0)
    standard_curves.select { |x| x.compound == compound && x.column == column }
  end

  def attach_standards_to_samples
    # TODO: remove this once references have been removed
  end
end
