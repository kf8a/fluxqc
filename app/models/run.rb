# The Run class is the root class of the system.
# It holds references to incubations and standards.
# A run represents one sampling time. It consists of all of the samples
# taken during a sampling event on a particular study
class Run < ActiveRecord::Base
  has_many :incubations, -> {order 'treatment, replicate' },  :dependent => :destroy
  has_many :samples, dependent: :destroy
  has_many :standard_curves, dependent: :destroy
  has_one :standard_curve_organizer, dependent: :destroy

  mount_uploader :setup_file, SetupUploader
  mount_uploader :data_file, DataUploader

  accepts_nested_attributes_for :incubations, :samples

  scope :by_state, ->(state){where(:workflow_state => state) }

  after_save :recompute_fluxes

  include Workflow
  workflow do
    state :uploaded do
      event :accept,  :transitions_to => :accepted
    end
    state :accepted do
      event :approve, :transitions_to => :approved
      event :reject,  :transitions_to => :rejected
    end
    state :approved do
      event :publish, :transitions_to => :published
      event :reject,  :transitions_to => :rejected
      event :unapprove, :transitions_to => :accepted
    end
    state :published do
      event :unpublish, :transitions_to => :approved
    end

    state :rejected do
      event :unreject, :transitions_to => :uploaded
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
    incubations.each do |i|
      i.fluxes.each do |f|
        f.flux
        f.save
      end
    end
  end

  def attach_standards_to_samples
    samples.each do |sample|
      sample.attach_standard_curves
      sample.save
    end
  end
end

# == Schema Information
#
# Table name: runs
#
#  id             :integer          not null, primary key
#  sampled_on     :date
#  run_on         :date
#  study          :string(255)
#  comment        :text
#  name           :string(255)
#  workflow_state :string(255)
#  released       :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  setup_file     :string(255)
#  data_file      :string(255)
#

