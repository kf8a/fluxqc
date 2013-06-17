require 'spec_helper'

describe Plot do
  it {should have_many :campaigns}
end

# == Schema Information
#
# Table name: plots
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

