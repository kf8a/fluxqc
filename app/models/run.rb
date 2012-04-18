class Run < ActiveRecord::Base
  has_many :incubations,  :dependent => :destroy, :order => 'treatment, replicate'
  has_many :samples, :dependent => :destroy

  mount_uploader :setup_file, SetupUploader
  mount_uploader :data_file, DataUploader

  accepts_nested_attributes_for :incubations, :samples

  scope :by_state, ->(state){where(:workflow_state => state) }

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
end
# == Schema Information
#
# Table name: runs
#
#  id             :integer         not null, primary key
#  sampled_on     :date
#  run_on         :date
#  study          :string(255)
#  comment        :text
#  name           :string(255)
#  workflow_state :string(255)
#  released       :boolean
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  setup_file     :string(255)
#  data_file      :string(255)
#

