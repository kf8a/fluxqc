class Standard < ActiveRecord::Base
  belongs_to :run
  belongs_to :compound
  has_many :measurements

  # attr_accessible :title, :body
end
