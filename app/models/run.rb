class Run < ActiveRecord::Base
  has_many :incubations,  :dependent => :destroy
  mount_uploader :setup_file, SetupUploader
  mount_uploader :data_file, DataUploader

  accepts_nested_attributes_for :incubations

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

    state :rejected
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
end
