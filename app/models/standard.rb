# frozen_string_literal: true

# Represents a standard
class Standard < ActiveRecord::Base
  belongs_to :compound
  belongs_to :standard_curve
end
