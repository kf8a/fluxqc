class Run < ActiveRecord::Base
  has_many :incubations

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
      event :reject, :transitions_to => :rejected
      event :recall, :transitions_to => :approved
    end

    state :rejected
  end

  def total_fluxes
    0
  end
  
  def approved_fluxes
    0
  end
end
