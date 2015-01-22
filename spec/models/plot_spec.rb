require 'rails_helper'

describe Plot do
  it {is_expected.to have_many :campaigns}
end

# == Schema Information
#
# Table name: plots
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
