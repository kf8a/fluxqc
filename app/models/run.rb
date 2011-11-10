class Run < ActiveRecord::Base
  has_many :incubations

  include Workflow
  workflow do
    state :uploaded do
      event :accept, :transitions_to => :accepted
    end
    state :accepted
    state :approved
    state :published

    state :rejected
  end
end
