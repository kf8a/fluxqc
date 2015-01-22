require 'rails_helper'

describe Template do
  it {is_expected.to have_many :setups}
end

# == Schema Information
#
# Table name: templates
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  study            :string(255)
#  plots            :text
#  samples_per_plot :integer
#  created_at       :datetime
#  updated_at       :datetime
#
